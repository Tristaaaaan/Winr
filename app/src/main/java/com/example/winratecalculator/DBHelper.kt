package com.example.winratecalculator

import android.content.ContentValues
import android.content.Context
import android.database.Cursor
import android.database.sqlite.SQLiteDatabase
import android.database.sqlite.SQLiteOpenHelper

class DBHelper(context: Context, factory: SQLiteDatabase.CursorFactory?) :
    SQLiteOpenHelper(context, DATABASE_NAME, factory, DATABASE_VERSION) {

    // below is the method for creating a database by a sqlite query
    override fun onCreate(db: SQLiteDatabase) {
        // below is a sqlite query, where column names
        // along with their data types is given
        val query = ("CREATE TABLE " + TABLE_NAME + " ("
                + ID_COL + " INTEGER PRIMARY KEY, " +
                IMG + " BLOB," +
                NAME + " TEXT," +
                DESIRED_WINRATE + " TEXT," +
                NUMBER_OF_BATTLES + " TEXT," +
                CURRENT_WINRATE + " TEXT," +
                PROGRESS + " TEXT," +
                WINS_NEEDED + " TEXT" + ")")

        // we are calling sqlite
        // method for executing our query
        db.execSQL(query)
    }

    override fun onUpgrade(db: SQLiteDatabase, p1: Int, p2: Int) {
        // this method is to check if table already exists
        db.execSQL("DROP TABLE IF EXISTS " + TABLE_NAME)
        onCreate(db)
    }

    // This method is for adding data in our database
    fun addName(dbImage : ByteArray, dbName : String, dbdesiredWinrate : String, dbnumberOfBattles : String, dbcurrentWinrate : String, dbProgress : String, dbwinsNeeded : String  ){

        // below we are creating
        // a content values variable
        val values = ContentValues()

        // we are inserting our values
        // in the form of key-value pair
        values.put(IMG, dbImage)
        values.put(NAME, dbName)
        values.put(DESIRED_WINRATE, dbdesiredWinrate)
        values.put(NUMBER_OF_BATTLES, dbnumberOfBattles)
        values.put(CURRENT_WINRATE, dbcurrentWinrate)
        values.put(PROGRESS, dbProgress)
        values.put(WINS_NEEDED, dbwinsNeeded)
        // here we are creating a
        // writable variable of
        // our database as we want to
        // insert value in our database
        val db = this.writableDatabase

        // all values are inserted into database
        db.insert(TABLE_NAME, null, values)

        // at last we are
        // closing our database
        db.close()
    }

    // below method is to get
    // all data from our database
    fun getAllData(): Cursor? {

        // here we are creating a readable
        // variable of our database
        // as we want to read value from it
        val db = this.readableDatabase

        // below code returns a cursor to
        // read data from the database
        val columns = arrayOf(IMG, NAME, PROGRESS, DESIRED_WINRATE)
        val query = "SELECT ${columns.joinToString()} FROM $TABLE_NAME"
        return db.rawQuery(query, null)

    }

//  Table Details
    companion object{
        // here we have defined variables for our database

        // below is variable for database name
        private val DATABASE_NAME = "WinRateHistory"

        // below is the variable for database version
        private val DATABASE_VERSION = 1

        // below is the variable for table name
        val TABLE_NAME = "userHistory"

        // below is the variable for id column
        val ID_COL = "id"

        val IMG = "dbImage"

        val NAME = "dbName"

        // below is the variable for name column
        val DESIRED_WINRATE = "dbdesiredWinrate"

        // below is the variable for age column
        val NUMBER_OF_BATTLES = "dbnumberOfBattles"

        val CURRENT_WINRATE = "dbcurrentWinrate"

        val PROGRESS = "dbProgress"

        val WINS_NEEDED = "dbwinsNeeded"
    }
}