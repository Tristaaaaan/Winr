package com.example.winratecalculator

import android.graphics.BitmapFactory
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.ProgressBar
import android.widget.TextView
import androidx.recyclerview.widget.RecyclerView
import de.hdodenhof.circleimageview.CircleImageView


class HistoryAdapter (private val historyList: ArrayList<WinRates>) : RecyclerView.Adapter<HistoryAdapter.MyViewHolder> () {

        override fun onCreateViewHolder(
                parent: ViewGroup,
                viewType: Int
        ): HistoryAdapter.MyViewHolder {
                val itemView = LayoutInflater.from(parent.context).inflate(R.layout.history_items,parent,false)
                return MyViewHolder(itemView)
        }

        override fun onBindViewHolder(holder: HistoryAdapter.MyViewHolder, position: Int) {
                val currentItem = historyList[position]
                holder.imageName.setImageBitmap(BitmapFactory.decodeByteArray(currentItem.imageID, 0, currentItem.imageID.size))
                holder.progressName.text = currentItem.name
                holder.yourDesiredWinRate.text = currentItem.desiredWR
                holder.progressVal.progress = currentItem.currentprogress

                // Set the image
        }

        override fun getItemCount(): Int {
                return historyList.size
        }

        class MyViewHolder(itemView: View) : RecyclerView.ViewHolder(itemView) {
                val imageName : CircleImageView = itemView.findViewById(R.id.imageName)
                val progressName : TextView = itemView.findViewById(R.id.progressName)
                val yourDesiredWinRate : TextView = itemView.findViewById(R.id.yourDesiredWinRate)
                val progressVal : ProgressBar = itemView.findViewById(R.id.progressValue)
        }

}
