package com.example.winratecalculator

import android.graphics.BitmapFactory
import android.os.Bundle
import android.util.Log
import androidx.fragment.app.Fragment
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.LinearLayout
import android.widget.ListView
import androidx.recyclerview.widget.LinearLayoutManager
import androidx.recyclerview.widget.RecyclerView
import com.example.winratecalculator.databinding.ActivityMainBinding
import com.example.winratecalculator.databinding.FragmentHistoryBinding


class History : Fragment() {

    private lateinit var historyArrayList: ArrayList<WinRates>
    private lateinit var adapter: HistoryAdapter
    private lateinit var historyList: RecyclerView
    private lateinit var noInfo : LinearLayout
    lateinit var images : Array<ByteArray>
    lateinit var name : Array<String>
    lateinit var desiredWR : Array<String>
    lateinit var currentProgress : Array<Int>
    override fun onCreateView(
        inflater: LayoutInflater, container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View? {

        return inflater.inflate(R.layout.fragment_history, container, false)
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

    }

    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)

        dataInitialize()

        val layoutManager = LinearLayoutManager(context)

        noInfo = view.findViewById(R.id.noData)
        historyList = view.findViewById(R.id.historyList)

        // Check if the historyArrayList is empty
        if (historyArrayList.isEmpty()) {
            // Hide the RecyclerView and show the noInfo LinearLayout
            historyList.visibility = View.GONE
            noInfo.visibility = View.VISIBLE
        } else {
            // Show the RecyclerView and hide the noInfo LinearLayout
            historyList.visibility = View.VISIBLE
            noInfo.visibility = View.GONE
            historyList.layoutManager = layoutManager
            historyList.setHasFixedSize(true)
            adapter = HistoryAdapter(historyArrayList)
            historyList.adapter = adapter
        }
    }

    private fun dataInitialize() {
        historyArrayList = arrayListOf<WinRates>()

        val db = DBHelper(requireContext(), null)


        val cursor = db.getAllData()

        // Check if the cursor has data
        if (cursor != null && cursor.moveToFirst()) {
            do {
                val image = cursor.getBlob(cursor.getColumnIndex("dbImage"))
                val name = cursor.getString(cursor.getColumnIndex("dbName"))
                val desiredWRStr = cursor.getString(cursor.getColumnIndex("dbdesiredWinrate"))
                val currentProgress = cursor.getString(cursor.getColumnIndex("dbProgress"))


                val desiredWR = desiredWRStr.toDoubleOrNull()
                if (desiredWR != null) {
                    val formattedWR = if (desiredWR % 1.0 == 0.0) {
                        "${desiredWR.toInt()}%" // Format as an integer with "%"
                    } else {
                        desiredWRStr + "%" // Add "%" to the string
                    }

                    // Create a WinRates object with the retrieved data
                    val user = WinRates(image, name, formattedWR, currentProgress.toInt())

                    // Add the WinRates object to the ArrayList
                    historyArrayList.add(user)
                } else {
                    // Handle the case where parsing failed for desiredWR
                    // You might want to use a default value or handle the error in another way
                }

            } while (cursor.moveToNext())

            // Close the cursor after you've extracted the data
            cursor.close()
        }

    }
}


