using System;
using System.Threading;
using MonoTouch.Foundation;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace KittenViewerTouch
{


	public class TaskManager
	{
		static int MAX_THREADS = 0;
		static Stack<Task> pendingTasks;
		static bool cancel;
		static SemaphoreSlim jobSemaphore;
		static SemaphoreSlim dataSemaphore;

		
		static TaskManager()
		{
			pendingTasks = new Stack<Task>();
			
			int cpuCount = Environment.ProcessorCount;
			MAX_THREADS = 2;//cpuCount * 2;
			jobSemaphore = new SemaphoreSlim( MAX_THREADS );
			dataSemaphore = new SemaphoreSlim( 0 );


			cancel = false;
			
			for ( int j = 0; j < MAX_THREADS; j++ )
			{

				Thread t = new Thread( () =>
				{
					while ( true )
					{
						dataSemaphore.Wait( );
						jobSemaphore.Wait();
						Task task = null;
						if ( pendingTasks.Count > 0 )
						{
							lock ( pendingTasks )
							{
								if ( pendingTasks.Count > 0 )
								{
									task = pendingTasks.Pop();
								}
							}
						}
						
						if ( null != task )
						{
							RunTask(task);
						}
						
						if ( cancel )
						{
							break;
						}
					}
				} );

				t.Start();
			}
		}
		
		public static void SubmitTask(Task f)
		{
			lock ( pendingTasks )
			{
				pendingTasks.Push(f);
			}
			dataSemaphore.Release();
		}
		
		private static void RunTask(Task f)
		{
			try
			{
				f.RunSynchronously();
			}
			finally
			{
				jobSemaphore.Release();
			}
		}
	}
}

