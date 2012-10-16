package com.s3mobileapps.memorydemo;

import android.app.Activity;
import android.os.Bundle;
import android.view.View;
import android.widget.Button;

public class GoBackActivity extends Activity
{

    private Button m_backButton;

    @Override protected void onCreate( final Bundle savedInstanceState )
    {
        super.onCreate( savedInstanceState );
        setContentView( R.layout.go_back );

        m_backButton = (Button) findViewById( R.id.btn_go_back );
        m_backButton.setOnClickListener( new View.OnClickListener()
        {
            public void onClick( final View aView )
            {
                finish();
            }
        } );
    }
}
