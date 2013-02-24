using System;
using MonoTouch.UIKit;

namespace KittenViewerTouch
{ 
	public class UIImageViewFromUrl : UIImageView
	{

		public object anObject = new object();

		string _url;
		public string Url {
			get
			{
				return _url;
			}
			set
			{
				if (_url != value)
				{
					lock( anObject)
					{
						if (_url != value)
						{
							_url = value;
						}
					}
				}

			}
		}


		public UIImageViewFromUrl()
		{
		}
	
		public UIImageViewFromUrl( UIImage image) :base(image)
		{
		}
	}
}

