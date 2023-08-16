package com.example.winratecalculator

import android.os.Parcel
import android.os.Parcelable

data class WinRates( var imageID : ByteArray, var name : String, var desiredWR : String,
                       var currentprogress : Int, var id : String) : Parcelable {
    constructor(parcel: Parcel) : this(
        parcel.createByteArray()!!,
        parcel.readString()!!,
        parcel.readString()!!,
        parcel.readInt(),
        parcel.readString()!!
    ) {
    }

    override fun writeToParcel(parcel: Parcel, flags: Int) {
        parcel.writeByteArray(imageID)
        parcel.writeString(name)
        parcel.writeString(desiredWR)
        parcel.writeInt(currentprogress)
        parcel.writeString(id)
    }

    override fun describeContents(): Int {
        return 0
    }

    companion object CREATOR : Parcelable.Creator<WinRates> {
        override fun createFromParcel(parcel: Parcel): WinRates {
            return WinRates(parcel)
        }

        override fun newArray(size: Int): Array<WinRates?> {
            return arrayOfNulls(size)
        }
    }
}