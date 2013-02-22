using System;
using System.Drawing;

using MonoTouch.Foundation;
using MonoTouch.UIKit;

namespace KittenViewerTouch
{

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
