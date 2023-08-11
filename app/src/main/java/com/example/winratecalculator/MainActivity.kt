package com.example.winratecalculator

import android.content.ContentValues.TAG
import androidx.appcompat.app.AppCompatActivity
import android.os.Bundle
import android.util.Log
import android.widget.TextView
import androidx.fragment.app.Fragment
import com.example.winratecalculator.databinding.ActivityMainBinding
import com.google.android.gms.ads.AdListener
import com.google.android.gms.ads.AdRequest
import com.google.android.gms.ads.AdView
import com.google.android.gms.ads.LoadAdError
import com.google.android.gms.ads.MobileAds
import com.google.android.gms.ads.RequestConfiguration

class MainActivity : AppCompatActivity() {
    private lateinit var binding : ActivityMainBinding
    private lateinit var mAdView : AdView
    private lateinit var fragmentName : TextView

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)

        fragmentName = findViewById(R.id.fragmentName)

        MobileAds.initialize(this) {}

        val testDeviceIds = listOf("701385E5FF04659377429E9392BEFD5C")
        val configuration = RequestConfiguration.Builder().setTestDeviceIds(testDeviceIds).build()
        MobileAds.setRequestConfiguration(configuration)

        mAdView = findViewById(R.id.adView)
        val adRequest = AdRequest.Builder().build()
        mAdView.loadAd(adRequest)

        mAdView.adListener = object: AdListener() {
            override fun onAdClicked() {
            }

            override fun onAdClosed() {
            }

            override fun onAdFailedToLoad(adError : LoadAdError) {
                Log.d(TAG, "Ad failed to load: $adError")
            }

            override fun onAdImpression() {
            }

            override fun onAdLoaded() {
                Log.d(TAG, "Ad loaded")
            }

            override fun onAdOpened() {

            }
        }

        binding = ActivityMainBinding.inflate(layoutInflater)
        setContentView(binding.root)
        replaceFragment(History())
        binding.bottomNavigationView.setOnItemSelectedListener { item ->
            val fragmentTitle: CharSequence = when (item.itemId) {
                R.id.home -> {
                    replaceFragment(Home())
                    "Record"
                }
                R.id.history -> {
                    replaceFragment(History())
                    "Home"
                }
                R.id.account -> {
                    replaceFragment(Account())
                    "Account"
                }
                else -> ""
            }

            // Update the TextView text
            binding.fragmentName.text = fragmentTitle

            true
        }

    }

    private fun replaceFragment(fragment : Fragment) {

        val fragmentManager = supportFragmentManager
        val fragmentTransaction = fragmentManager.beginTransaction()
        fragmentTransaction.replace(R.id.frame_layout,fragment)
        fragmentTransaction.commit()

    }
}