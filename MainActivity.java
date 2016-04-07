package com.example.adam.irthing;

import android.hardware.ConsumerIrManager;
import android.os.Bundle;
import android.support.design.widget.FloatingActionButton;
import android.support.design.widget.Snackbar;
import android.support.v7.app.AppCompatActivity;
import android.support.v7.widget.Toolbar;
import android.util.Log;
import android.view.MotionEvent;
import android.view.View;
import android.view.Menu;
import android.view.MenuItem;
import android.widget.Button;

public class MainActivity extends AppCompatActivity {

    private boolean hasEmitter;
    private ConsumerIrManager irManager;
    private Button forwardButton;
    private Button backwardButton;
    private Button leftButton;
    private Button rightButton;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);
        Toolbar toolbar = (Toolbar) findViewById(R.id.toolbar);
        setSupportActionBar(toolbar);

        forwardButton = (Button) findViewById(R.id.forward);
        backwardButton = (Button) findViewById(R.id.backward);
        leftButton = (Button) findViewById(R.id.left);
        rightButton = (Button) findViewById(R.id.right);

        forwardButton.setOnTouchListener(new View.OnTouchListener(){
            public boolean onTouch(View view, MotionEvent mE)
            {
                if(mE.getAction() == MotionEvent.ACTION_DOWN)
                {
                    SendForward(forwardButton);
                }
                else if(mE.getAction() == MotionEvent.ACTION_UP)
                {
                    SendStop(forwardButton);
                }

                return false;
            }

        });

        backwardButton.setOnTouchListener(new View.OnTouchListener(){
            public boolean onTouch(View view, MotionEvent mE)
            {
                if(mE.getAction() == MotionEvent.ACTION_DOWN)
                {
                    SendBack(backwardButton);
                }
                else if(mE.getAction() == MotionEvent.ACTION_UP)
                {
                    SendStop(backwardButton);
                }

                return false;
            }

        });

        leftButton.setOnTouchListener(new View.OnTouchListener(){
            public boolean onTouch(View view, MotionEvent mE)
            {
                if(mE.getAction() == MotionEvent.ACTION_DOWN)
                {
                    SendLeft(leftButton);
                }
                else if(mE.getAction() == MotionEvent.ACTION_UP)
                {
                    SendStop(leftButton);
                }

                return false;
            }

        });

        rightButton.setOnTouchListener(new View.OnTouchListener(){
            public boolean onTouch(View view, MotionEvent mE)
            {
                if(mE.getAction() == MotionEvent.ACTION_DOWN)
                {
                    SendRight(rightButton);
                }
                else if(mE.getAction() == MotionEvent.ACTION_UP)
                {
                    SendStop(rightButton);
                }

                return false;
            }

        });

        irManager = (ConsumerIrManager) this.getSystemService(CONSUMER_IR_SERVICE);
        ConsumerIrManager.CarrierFrequencyRange[] frequencies = irManager.getCarrierFrequencies();
        int minFreq = frequencies[0].getMinFrequency();
        int maxFreq = frequencies[0].getMaxFrequency();

        Log.d("minFreq", Integer.toString(minFreq));
        Log.d("maxFreq", Integer.toString(maxFreq));

        hasEmitter = irManager.hasIrEmitter();

        Log.d("Has Emitter", Boolean.toString(hasEmitter));

    }

    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
        // Inflate the menu; this adds items to the action bar if it is present.
        getMenuInflater().inflate(R.menu.menu_main, menu);
        return true;
    }

    @Override
    public boolean onOptionsItemSelected(MenuItem item) {
        // Handle action bar item clicks here. The action bar will
        // automatically handle clicks on the Home/Up button, so long
        // as you specify a parent activity in AndroidManifest.xml.
        int id = item.getItemId();

        //noinspection SimplifiableIfStatement
        if (id == R.id.action_settings) {
            return true;
        }

        return super.onOptionsItemSelected(item);
    }

    public void ButtonPressed(View view)
    {


        if(hasEmitter)
        {
                           //Start(5)  pad+buttons(3)  directions(2)  pads(2)  power(3)
                //int[] transmitPattern = {30000, 30000, 50000, 30000, 20000, 20000, 30000, 100000};  //works; forwards full power

                //works?    backwards full power w/ 8 pulses
                //int[] transmitPattern = {3000, 3000, 30000, 30000, 50000, 70000, 30000, 100000};  //test with 8 pulses (same as working one)

                //works? 0 power, forwards
                int[] transmitPattern = {10000, 10000, 10000, 10000, 50000, 30000, 20000, 50000};

                //int[] transmitPattern = {30000, 30000, 50000, 70000, 30000, 100000};  //doesn't work; backwards full power

                //int[] transmitPattern = {50000, 50000, 50000, 50000, 50000, 50000, 50000, 50000, 50000};  //works? (I think)

                irManager.transmit(40000, transmitPattern);     //works

                //irManager.transmit(35000, transmitPattern);


        }

    }

    public void SendForward(View v)
    {
        if(hasEmitter)
        {
            int[] transmitPattern = {30000, 30000, 50000, 30000, 20000, 20000, 30000, 100000};

            irManager.transmit(40000, transmitPattern);

            Log.d("IRSend", "Forward");
        }
    }

    public void SendLeft(View v)
    {
        if(hasEmitter)
        {
            int[] transmitPattern = {30000, 30000, 50000, 40000, 10000, 20000, 30000, 100000};

            irManager.transmit(40000, transmitPattern);

            Log.d("IRSend", "Left");
        }
    }

    public void SendRight(View v)
    {
        if(hasEmitter)
        {
            int[] transmitPattern = {30000, 30000, 50000, 30000, 10000, 30000, 30000, 100000};

            irManager.transmit(40000, transmitPattern);

            Log.d("IRSend", "Right");
        }
    }

    public void SendBack(View v)
    {
        if(hasEmitter)
        {
            int[] transmitPattern = {30000, 30000, 30000, 30000, 50000, 70000, 30000, 100000};

            irManager.transmit(40000, transmitPattern);

            Log.d("IRSend", "Backwards");
        }
    }

    public void SendStop(View v)
    {
        if(hasEmitter)
        {
            int[] transmitPattern = {30000, 30000, 30000, 30000, 50000, 30000, 20000, 100000};

            irManager.transmit(40000, transmitPattern);

            Log.d("IRSend", "Stop");
        }
    }

}
