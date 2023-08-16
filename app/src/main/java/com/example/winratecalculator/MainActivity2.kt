package com.example.winratecalculator

import android.app.Activity
import android.content.Intent
import android.graphics.Bitmap
import android.graphics.BitmapFactory
import android.graphics.Color
import android.graphics.drawable.BitmapDrawable
import androidx.appcompat.app.AppCompatActivity
import android.os.Bundle
import android.text.Editable
import android.util.Log
import android.view.View
import android.widget.Button
import android.widget.ImageButton
import android.widget.ImageView
import android.widget.LinearLayout
import android.widget.RelativeLayout
import android.widget.TextView
import com.google.android.material.textfield.TextInputEditText
import com.google.android.material.textfield.TextInputLayout
import java.io.ByteArrayOutputStream
import kotlin.math.ceil

class MainActivity2 : AppCompatActivity() {

    private lateinit var editDesiredWinrate : TextInputEditText
    private lateinit var editNumberOfBattles : TextInputEditText
    private lateinit var editCurrentWinrate : TextInputEditText
    private lateinit var winsNeeded : TextView
    private lateinit var submitButton : Button
    private lateinit var relativeBox : RelativeLayout
    private lateinit var closeButton : ImageButton
    private lateinit var infoView : ImageView
    private lateinit var refreshButton : ImageButton
    private lateinit var imageHolder : ImageView
    private lateinit var cardImage : LinearLayout
    private lateinit var editProgressName : TextInputEditText
    private lateinit var textInputLayout4 : TextInputLayout
    private lateinit var textInputLayout3 : TextInputLayout
    private lateinit var textInputLayout2 : TextInputLayout
    private lateinit var textInputLayout : TextInputLayout
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main2)

        imageHolder = findViewById(R.id.updateImage)
        editDesiredWinrate = findViewById(R.id.updateDesiredWinRate)
        editNumberOfBattles = findViewById(R.id.updateNumberOfBattles)
        editCurrentWinrate = findViewById(R.id.updateCurrentWinRate)
        winsNeeded = findViewById(R.id.winsNeeded)
        submitButton = findViewById(R.id.submitButton)
        relativeBox = findViewById(R.id.relativeBox)
        closeButton = findViewById(R.id.closeButton)
        infoView = findViewById(R.id.infoView)
        refreshButton = findViewById(R.id.refreshButton)
        relativeBox.visibility = View.GONE
        cardImage = findViewById(R.id.cardHolder)
        editProgressName = findViewById(R.id.updateProgressName)
        textInputLayout4 = findViewById(R.id.textInputLayout4)
        textInputLayout3 = findViewById(R.id.textInputLayout3)
        textInputLayout2 = findViewById(R.id.textInputLayout2)
        textInputLayout = findViewById(R.id.textInputLayout)

        // Retrieve the data from the intent
        val receivedData = intent.getStringExtra("selectedItem")

        // Log the received data
        Log.d("NewActivity", "Received data: $receivedData")


        // Initialize the database helper
        val db = DBHelper(this, null)

        if (receivedData != null) {
            val loadedData = db.loadData(receivedData.toString())

            if (loadedData != null && loadedData.moveToFirst()) {
                val imageIndex = loadedData.getColumnIndex("dbImage")
                val nameIndex = loadedData.getColumnIndex("dbName")
                val desiredWRIndex = loadedData.getColumnIndex("dbdesiredWinrate")
                val numberOfBattlesIndex = loadedData.getColumnIndex("dbnumberOfBattles")
                val currentWinrateIndex = loadedData.getColumnIndex("dbcurrentWinrate")

                val image = loadedData.getBlob(imageIndex)
                val name = loadedData.getString(nameIndex)
                val desiredWRStr = loadedData.getString(desiredWRIndex)
                val numberOfBattles = loadedData.getInt(numberOfBattlesIndex)
                val currentWinrate = loadedData.getInt(currentWinrateIndex)

                // Populate UI elements with loaded data
                imageHolder.setImageBitmap(BitmapFactory.decodeByteArray(image, 0, image?.size ?: 0))
                editProgressName.setText(name)

                val editableDesiredWinrate = Editable.Factory.getInstance().newEditable(desiredWRStr)
                editDesiredWinrate.text = editableDesiredWinrate

                val editableTextBattles = Editable.Factory.getInstance().newEditable(numberOfBattles.toString())
                editNumberOfBattles.text = editableTextBattles

                val editableTextCWR = Editable.Factory.getInstance().newEditable(currentWinrate.toString())
                editCurrentWinrate.text = editableTextCWR

            } else {
                Log.d("MainActivity2", "No data found for the provided ID: $receivedData")
            }

            loadedData?.close() // Close the Cursor when done
        } else {
            Log.d("MainActivity2", "No ID received.")
        }


        editProgressName.setOnFocusChangeListener { _, hasFocus ->
            if (hasFocus) {
                textInputLayout4.helperText = "(e.g. Ixia, Novaria)"
            } else {
                textInputLayout4.helperText = null // Clear the helper text when not focused
            }
        }

        editDesiredWinrate.setOnFocusChangeListener { _, hasFocus ->
            if (hasFocus) {
                textInputLayout.helperText = "Must be below 100"
            } else {
                textInputLayout.helperText = null // Clear the helper text when not focused
            }
        }

        editCurrentWinrate.setOnFocusChangeListener { _, hasFocus ->
            if (hasFocus) {
                textInputLayout3.helperText = "Must be below 100 and lower than desired win rate"
            } else {
                textInputLayout3.helperText = null // Clear the helper text when not focused
            }
        }

        cardImage.setOnClickListener {
            uploadImage(imageHolder)
        }

        submitButton.setOnClickListener {
            computeWinRate()
        }

        closeButton.setOnClickListener {
            removeNotice()
        }

        refreshButton.setOnClickListener {
            clearWidgets()
        }

    }


    private fun uploadImage(imageHolder: ImageView?) {
        val intent = Intent()

        intent.action = Intent.ACTION_GET_CONTENT
        intent.type = "image/*"
        startActivityForResult(intent,1)
    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        super.onActivityResult(requestCode, resultCode, data)
        if (requestCode == 1 && resultCode == Activity.RESULT_OK && data != null) {
            val selectedImageUri = data.data
            imageHolder.setImageURI(selectedImageUri)
        }
    }


    private fun clearWidgets() {
        relativeBox.visibility = View.GONE
        editDesiredWinrate.setText("")
        editCurrentWinrate.setText("")
        editNumberOfBattles.setText("")
        editProgressName.setText("")
    }

    private fun removeNotice() {
        relativeBox.visibility = View.GONE
    }


    private fun computeWinRate() {
        if (editDesiredWinrate.text.isNullOrEmpty() ||
            editNumberOfBattles.text.isNullOrEmpty() ||
            editCurrentWinrate.text.isNullOrEmpty()) {
            if (relativeBox.visibility == View.GONE) {
                relativeBox.visibility = View.VISIBLE
            }
            closeButton.visibility = View.VISIBLE
            winsNeeded.setTextColor(Color.parseColor("#71192F"))
            infoView.setImageResource(R.drawable.baseline_error_24)
            closeButton.setImageResource(R.drawable.baseline_close_24)
            relativeBox.setBackgroundColor(Color.parseColor("#FCE8DB"))
            winsNeeded.text = "Make sure the fields are not empty."
        } else {
            val numberOfBattles = editNumberOfBattles.text.toString().toDouble()
            val currentWinrate = editCurrentWinrate.text.toString().toDouble()
            val desiredWinrate = editDesiredWinrate.text.toString().toDouble()
            val progressIdentity = editProgressName.text.toString()
            val neededWins =
                (desiredWinrate * numberOfBattles - currentWinrate * numberOfBattles) / (100 - desiredWinrate)
            if (neededWins.toInt() <= 0) {
                if (relativeBox.visibility == View.GONE) {
                    relativeBox.visibility = View.VISIBLE
                }
                closeButton.visibility = View.VISIBLE
                winsNeeded.setTextColor(Color.parseColor("#755118"))
                infoView.setImageResource(R.drawable.baseline_warning_24)
                relativeBox.setBackgroundColor(Color.parseColor("#FEF7D1"))
                closeButton.setImageResource(R.drawable.baseline_close2_24)
                winsNeeded.text = "Make sure the inputs are valid."
            } else {
                val db = DBHelper(this, null)

                val drawable = imageHolder.drawable
                val bitmap = (drawable as BitmapDrawable).bitmap

                val byteArrayOutputStream = ByteArrayOutputStream()
                bitmap.compress(Bitmap.CompressFormat.JPEG, 100, byteArrayOutputStream)
                val imgByteArray = byteArrayOutputStream.toByteArray()
                val progress = (currentWinrate / desiredWinrate) * 100
                // calling method to add
                // name to our database


                // THIS SHOULD BE UPDATE NOT ADD
                db.addName(imgByteArray, progressIdentity, desiredWinrate.toString(), numberOfBattles.toString(), currentWinrate.toString(), progress.toInt().toString(), neededWins.toString())

                if (relativeBox.visibility == View.GONE) {
                    relativeBox.visibility = View.VISIBLE

                }
                closeButton.visibility = View.GONE
                infoView.setImageResource(R.drawable.baseline_check_24)
                winsNeeded.setTextColor(Color.parseColor("#0C2A75"))
                relativeBox.setBackgroundColor(Color.parseColor("#D7F1FD"))


                val gameOrGames = if (ceil(neededWins).toInt() == 1) "game" else "games"
                winsNeeded.text = "You need to win ${ceil(neededWins).toInt()} $gameOrGames without losing to achieve your desired win rate.".format(neededWins)
            }
        }
    }
}