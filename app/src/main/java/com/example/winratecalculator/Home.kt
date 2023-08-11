package com.example.winratecalculator

import android.app.Activity
import android.content.Intent
import android.graphics.Bitmap
import android.graphics.Color
import android.graphics.drawable.BitmapDrawable
import android.os.Bundle
import androidx.fragment.app.Fragment
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
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

class Home : Fragment() {

    private lateinit var desiredWinrate : TextInputEditText
    private lateinit var numberOfBattles : TextInputEditText
    private lateinit var currentWinrate : TextInputEditText
    private lateinit var winsNeeded : TextView
    private lateinit var submitButton : Button
    private lateinit var relativeBox : RelativeLayout
    private lateinit var closeButton : ImageButton
    private lateinit var infoView : ImageView
    private lateinit var refreshButton : ImageButton
    private lateinit var imageHolder : ImageView
    private lateinit var cardImage : LinearLayout
    private lateinit var progressName : TextInputEditText
    private lateinit var textInputLayout4 : TextInputLayout
    private lateinit var textInputLayout3 : TextInputLayout
    private lateinit var textInputLayout2 : TextInputLayout
    private lateinit var textInputLayout : TextInputLayout
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        arguments?.let {
        }
    }

    override fun onCreateView(
        inflater: LayoutInflater, container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View? {
        // Inflate the layout for this fragment
        val rootView = inflater.inflate(R.layout.fragment_home, container, false)
        imageHolder = rootView.findViewById(R.id.uploadImage)
        desiredWinrate = rootView.findViewById(R.id.desiredWinrate)
        numberOfBattles = rootView.findViewById(R.id.numberOfBattles)
        currentWinrate = rootView.findViewById(R.id.currentWinrate)
        winsNeeded = rootView.findViewById(R.id.winsNeeded)
        submitButton = rootView.findViewById(R.id.submitButton)
        relativeBox = rootView.findViewById(R.id.relativeBox)
        closeButton = rootView.findViewById(R.id.closeButton)
        infoView = rootView.findViewById(R.id.infoView)
        refreshButton = rootView.findViewById(R.id.refreshButton)
        relativeBox.visibility = View.GONE
        cardImage = rootView.findViewById(R.id.cardHolder)
        progressName = rootView.findViewById(R.id.progressName)
        textInputLayout4 = rootView.findViewById(R.id.textInputLayout4)
        textInputLayout3 = rootView.findViewById(R.id.textInputLayout3)
        textInputLayout2 = rootView.findViewById(R.id.textInputLayout2)
        textInputLayout = rootView.findViewById(R.id.textInputLayout)

        progressName.setOnFocusChangeListener { _, hasFocus ->
            if (hasFocus) {
                textInputLayout4.helperText = "(e.g. Ixia, Novaria)"
            } else {
                textInputLayout4.helperText = null // Clear the helper text when not focused
            }
        }

        desiredWinrate.setOnFocusChangeListener { _, hasFocus ->
            if (hasFocus) {
                textInputLayout.helperText = "Must be below 100"
            } else {
                textInputLayout.helperText = null // Clear the helper text when not focused
            }
        }

        currentWinrate.setOnFocusChangeListener { _, hasFocus ->
            if (hasFocus) {
                textInputLayout3.helperText = "Must be below 100 and lower than desired win rate"
            } else {
                textInputLayout3.helperText = null // Clear the helper text when not focused
            }
        }

        cardImage.setOnClickListener() {
            uploadImage(imageHolder)
        }

        submitButton.setOnClickListener() {
            computeWinRate()
        }

        closeButton.setOnClickListener() {
            removeNotice()
        }

        refreshButton.setOnClickListener() {
            clearWidgets()
        }
        return rootView

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
        desiredWinrate.setText("")
        currentWinrate.setText("")
        numberOfBattles.setText("")
    }

    private fun removeNotice() {
        relativeBox.visibility = View.GONE
    }


    private fun computeWinRate() {
        if (desiredWinrate.text.isNullOrEmpty() ||
            numberOfBattles.text.isNullOrEmpty() ||
            currentWinrate.text.isNullOrEmpty()) {
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
            val numberOfBattles = numberOfBattles.text.toString().toDouble()
            val currentWinrate = currentWinrate.text.toString().toDouble()
            val desiredWinrate = desiredWinrate.text.toString().toDouble()
            val progressIdentity = progressName.text.toString()
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
                val db = DBHelper(requireContext(), null)

                val drawable = imageHolder.drawable
                val bitmap = (drawable as BitmapDrawable).bitmap

                val byteArrayOutputStream = ByteArrayOutputStream()
                bitmap.compress(Bitmap.CompressFormat.JPEG, 100, byteArrayOutputStream)
                val imgByteArray = byteArrayOutputStream.toByteArray()
                val progress = (currentWinrate / desiredWinrate) * 100
                // calling method to add
                // name to our database
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
