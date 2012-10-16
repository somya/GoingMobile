package com.s3mobileapps.memorydemo;

import android.app.Activity;
import android.content.Intent;
import android.net.Uri;
import android.os.Bundle;
import android.util.Log;
import android.view.View;
import android.widget.Button;
import android.widget.ImageView;

import java.util.Random;

public class MainActivity extends Activity
{
    private Button m_goForthButton;
    private ImageView m_mainImage;

    /**
     * Called when the activity is first created.
     */
    @Override
    public void onCreate( Bundle savedInstanceState )
    {
        super.onCreate( savedInstanceState );
        setContentView( R.layout.main );

        m_mainImage = (ImageView) findViewById( R.id.img_main );
        m_goForthButton = (Button) findViewById( R.id.btn_go_back );
        m_goForthButton.setOnClickListener(
            new View.OnClickListener()
            {
                public void onClick( final View aView )
                {
                    startActivity( new Intent( MainActivity.this, GoBackActivity.class ) );
                }
            } );
    }

    @Override protected void onResume()
    {
        super.onResume();

        Random r = new Random(  );

        String uriString = "http://lorempixel.com/320/200/people/" + r.nextInt( 10 );
        Log.d( "MainActivity.onResume", "uriString = " + uriString );

        m_mainImage.setImageURI( Uri.parse( uriString ) );
    }
}
