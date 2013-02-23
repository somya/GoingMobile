using System;
using MonoTouch.UIKit;
using MonoTouch.CoreGraphics;
using System.Drawing;
using System.Net;
using MonoTouch.Foundation;

namespace KittenViewerTouch
{
	public class KittenViewCell :  UITableViewCell
	{
		public UIImageView LeftImage { get; set; }
		public UIImageView RightImage { get; set; }

		public string LeftUrl { get; set; }
		public string RightUrl { get; set; }

		 UIImage emptyImage = new UIImage("empty.png");

		public KittenViewCell()
		{
		}

		public KittenViewCell( UITableViewCellStyle @default, string cellIdentifier ) : base( @default, cellIdentifier)
		{
			LeftImage = new UIImageView( emptyImage);
			RightImage = new UIImageView( emptyImage);

			this.ContentView.Add(LeftImage);
			this.ContentView.Add(RightImage);

			this.BackgroundColor = UIColor.Black;
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

		private void LoadImage(UIImageView imageView)
		{
			string url = string.Format( "http://placekitten.com/{0}/{1}", imageView.Bounds.Width, imageView.Bounds.Height );

			WebClient client = new WebClient();
			imageView.Image = new UIImage(NSData.FromArray(client.DownloadData(url)));
		}
	}
}

