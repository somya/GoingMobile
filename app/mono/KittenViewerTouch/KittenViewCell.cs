using System;
using MonoTouch.UIKit;

namespace KittenViewerTouch
{
	public class KittenViewCell :  UITableViewCell
	{
		public UIImageView LeftIamge { get; set; }
		public UIImageView RightIamge { get; set; }

		public string LeftUrl { get; set; }
		public string RightUrl { get; set; }

		public KittenViewCell()
		{
		}

		public KittenViewCell( UITableViewCellStyle @default, string cellIdentifier ) : base( @default, cellIdentifier)
		{
		}
	}
}

