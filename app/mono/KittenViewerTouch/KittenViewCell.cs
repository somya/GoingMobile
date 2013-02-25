using System;
using MonoTouch.UIKit;
using MonoTouch.CoreGraphics;
using System.Drawing;
using System.Net;
using MonoTouch.Foundation;
using System.Threading.Tasks;

namespace KittenViewerTouch
{
	public class KittenViewCell :  UITableViewCell
	{
		public UIImageViewFromUrl LeftImage { get; set; }
		public UIImageViewFromUrl RightImage { get; set; }

		public string LeftUrl { get; set; }
		public string RightUrl { get; set; }

		public int Row { get; set;}

		 UIImage emptyImage = new UIImage("empty.png");

		public KittenViewCell()
		{
		}

		public KittenViewCell( UITableViewCellStyle @default, string cellIdentifier ) : base( @default, cellIdentifier)
		{
			LeftImage = new UIImageViewFromUrl( emptyImage);
			RightImage = new UIImageViewFromUrl( emptyImage);

			this.ContentView.Add(LeftImage);
			this.ContentView.Add(RightImage);


		}

		public override void PrepareForReuse()
		{
			base.PrepareForReuse();
			LeftImage.Image = emptyImage;
			RightImage.Image = emptyImage;
		}

		public void LoadImages()
		{
			var maxX  = Bounds.Width;
			var randomWidh = 40 + ((new Random()).Next() % (int)(maxX - 80));
			RectangleF left, right;

			Bounds.Divide(randomWidh, CGRectEdge.MinXEdge, out left, out right);

			LeftImage.Frame = left.Inset(1,1);
			RightImage.Frame = right.Inset(1,1);

			LoadImage(LeftImage);
			LoadImage(RightImage);
		}

		private void LoadImage(UIImageViewFromUrl imageView)
		{

			imageView.Url =  string.Format( "http://placekitten.com/{0}/{1}", imageView.Bounds.Width * 2, imageView.Bounds.Height * 2 );
			var row = this.Row;
			var task = new Task<UIImage>( (url) => 
			{

				Console.WriteLine( "loading image for Row ={0}", row );
				if (imageView.Url == url) 
				{	
					WebClient client = new WebClient();
					var image = new UIImage(NSData.FromArray(client.DownloadData( (string)url )));
					return image;
				}
				return null;

			}, imageView.Url);

			task.ContinueWith( t => 
			{

				InvokeOnMainThread( () =>  
				{
					if (imageView.Url == (string)t.AsyncState) 
					{	
						UIView.Animate( 0.2 , () => {
							imageView.Alpha = 0;
						}, () => {
							UIView.Animate( 0.5 , () => {
							imageView.Image = t.Result;
							imageView.Alpha = 1;
							});
						});
						
					}
				});
			});

			TaskManager.SubmitTask(task );

		}
	}
}

