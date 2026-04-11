package com.example.imageviewer;

import android.os.Bundle;
import android.view.ViewGroup;
import android.widget.Button;
import android.widget.ImageView;

import androidx.appcompat.app.AppCompatActivity;

public class MainActivity extends AppCompatActivity {

    ImageView imageView;
    Button btnChangeImage, btnResize;

    boolean isImage1 = true;
    boolean isLarge = false;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        imageView = findViewById(R.id.imageView);
        btnChangeImage = findViewById(R.id.btnChangeImage);
        btnResize = findViewById(R.id.btnResize);

        // Change Image
        btnChangeImage.setOnClickListener(v -> {
            if (isImage1) {
                imageView.setImageResource(R.drawable.image2);
            } else {
                imageView.setImageResource(R.drawable.image1);
            }
            isImage1 = !isImage1;
        });

        // Change Dimensions
        btnResize.setOnClickListener(v -> {
            ViewGroup.LayoutParams params = imageView.getLayoutParams();

            if (isLarge) {
                params.width = 250;
                params.height = 200;
            } else {
                params.width = 500;
                params.height = 400;
            }

            imageView.setLayoutParams(params);
            isLarge = !isLarge;
        });
    }
}
