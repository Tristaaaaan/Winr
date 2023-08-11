package com.example.winratecalculator

import android.content.Context
import android.os.Bundle
import android.text.SpannableString
import android.text.style.StyleSpan
import android.view.Gravity
import androidx.fragment.app.Fragment
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.Button
import android.widget.TextView
import android.widget.Toast
import androidx.appcompat.app.AlertDialog
import org.w3c.dom.Text

// TODO: Rename parameter arguments, choose names that match
// the fragment initialization parameters, e.g. ARG_ITEM_NUMBER
private const val ARG_PARAM1 = "param1"
private const val ARG_PARAM2 = "param2"

/**
 * A simple [Fragment] subclass.
 * Use the [Account.newInstance] factory method to
 * create an instance of this fragment.
 */
class Account : Fragment() {
    // TODO: Rename and change types of parameters
    private var param1: String? = null
    private var param2: String? = null

    private lateinit var deleteButton : Button

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        arguments?.let {
            param1 = it.getString(ARG_PARAM1)
            param2 = it.getString(ARG_PARAM2)
        }
    }

    override fun onCreateView(
        inflater: LayoutInflater, container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View? {
        // Inflate the layout for this fragment
        val accountView =  inflater.inflate(R.layout.fragment_account, container, false)

        deleteButton = accountView.findViewById(R.id.deleteButton)

        deleteButton.setOnClickListener() {
            verifyDeletion()
        }
        return accountView
    }

    private fun verifyDeletion() {
        val db = DBHelper(requireContext(), null)

        val dataCursor = db.getAllData()

        if (dataCursor != null && dataCursor.moveToFirst()) {
            // Data exists, proceed with the delete confirmation dialog
            val dialogView = layoutInflater.inflate(R.layout.delete_confirmation, null)

            val alertDialog = AlertDialog.Builder(requireContext())
                .setTitle("Delete Confirmation")
                .setView(dialogView)
                .setPositiveButton("Yes") { dialog, which ->
                    // Handle the positive button click (delete action)
                    deleteDatas()
                    // No data, show the custom toast
                    customToast("Records has been deleted.")
                }
                .setNegativeButton("Cancel") { dialog, which ->
                    // Handle the negative button click (cancel action)
                }
                .create()

            // Find the TextView in the dialog layout
            val messageTextView = dialogView.findViewById<TextView>(R.id.confirmationLabel)

            // Create a SpannableString with the desired formatting
            val message = "By tapping Yes, the records you currently have will be deleted and will not be recovered anymore."
            val spannableMessage = SpannableString(message)
            val boldSpan = StyleSpan(android.graphics.Typeface.BOLD)
            spannableMessage.setSpan(
                boldSpan,
                message.indexOf("Yes"),
                message.indexOf("Yes") + "Yes".length,
                SpannableString.SPAN_EXCLUSIVE_EXCLUSIVE
            )

            // Set the formatted SpannableString as the text for the TextView
            messageTextView.text = spannableMessage

            alertDialog.show()
        } else {
            // No data, show the custom toast
            customToast("No data to delete.")
        }

        dataCursor?.close()

    }

//    Custom Toast Function
    private fun customToast(message: String) {
        val inflater = LayoutInflater.from(requireContext())
        val toastView = inflater.inflate(R.layout.customized_toast, null)

        // set the text of the TextView of the message
        val textView = toastView.findViewById<TextView>(R.id.toast_text)
        textView.text = message

        // create the toast
        val toast = Toast(requireContext())
        toast.apply {
            setGravity(Gravity.CENTER, 0, 40)
            duration = Toast.LENGTH_LONG
            view = toastView
            show()
        }
    }

    private fun deleteDatas() {
        val db = DBHelper(requireContext(), null)

        val tableName = DBHelper.TABLE_NAME // Use the constant from your DBHelper class for the table name
        db.deleteAllDataFromTable(tableName)
    }

    companion object {
        /**
         * Use this factory method to create a new instance of
         * this fragment using the provided parameters.
         *
         * @param param1 Parameter 1.
         * @param param2 Parameter 2.
         * @return A new instance of fragment Account.
         */
        // TODO: Rename and change types and number of parameters
        @JvmStatic
        fun newInstance(param1: String, param2: String) =
            Account().apply {
                arguments = Bundle().apply {
                    putString(ARG_PARAM1, param1)
                    putString(ARG_PARAM2, param2)
                }
            }
    }
}