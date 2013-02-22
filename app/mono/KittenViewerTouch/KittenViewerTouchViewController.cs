using System;
using System.Drawing;

using MonoTouch.Foundation;
using MonoTouch.UIKit;

namespace KittenViewerTouch
{
    public partial class KittenViewerTouchViewController : UITableViewController
    {
        public KittenViewerTouchViewController() : base ()
        {
        }
		
        public override void DidReceiveMemoryWarning()
        {
            // Releases the view if it doesn't have a superview.
            base.DidReceiveMemoryWarning( );
			
            // Release any cached data, images, etc that aren't in use.
        }
		
        public override void ViewDidLoad()
        {
            base.ViewDidLoad( );
			
            // Perform any additional setup after loading the view, typically from a nib.
            this.TableView.SeparatorStyle =  UITableViewCellSeparatorStyle.None;
            Title = "Kittens";
           
        }
		
        public override void ViewDidUnload()
        {
            base.ViewDidUnload( );
			
            // Clear any references to subviews of the main view in order to
            // allow the Garbage Collector to collect them sooner.
            //
            // e.g. myOutlet.Dispose (); myOutlet = null;
			
            ReleaseDesignerOutlets( );
        }
		
        public override bool ShouldAutorotateToInterfaceOrientation( UIInterfaceOrientation toInterfaceOrientation )
        {
            // Return true for supported orientations
            return ( toInterfaceOrientation == UIInterfaceOrientation.Portrait );
        }


    }

    public class KittenTableSource : UITableViewSource
    {

		public const string cellIdentifier = "KittenCell";

        public override int NumberOfSections(UITableView tableView)
        {
			return 1;
        }


		public override int RowsInSection(UITableView tableview, int section)
		{
			return 100;
		}

		public override UITableViewCell GetCell(UITableView tableView, NSIndexPath indexPath)
		{
			// request a recycled cell to save memory
			KittenViewCell cell = (KittenViewCell) tableView.DequeueReusableCell (cellIdentifier);
			// if there are no cells to reuse, create a new one
			if ( cell == null )
			{
				cell = new KittenViewCell( UITableViewCellStyle.Default, cellIdentifier );
			}
			return cell;
		}
    }
}

