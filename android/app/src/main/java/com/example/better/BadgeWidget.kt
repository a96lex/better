package com.example.better

import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.Context
import android.widget.RemoteViews

import android.app.PendingIntent
import android.content.Intent
import android.os.Build

import es.antonborri.home_widget.HomeWidgetPlugin

/**
 * Implementation of App Widget functionality.
 */
class BadgeWidget : AppWidgetProvider() {
    // private val CHANNEL = "timer_channel"


    // override fun onReceive(context: Context?, intent: Intent?) {
    //     super.onReceive(context, intent)

    //     if (intent?.action == "setText") {
    //         val flutterView = FlutterView(context)

    //         // Handle MethodChannel setup
    //         val channel = MethodChannel(
    //             flutterView
    //                 .flutterEngine!!
    //                 .dartExecutor
    //                 .binaryMessenger,
    //             CHANNEL
    //         )

    //         channel.setMethodCallHandler { call, result ->
    //             // Handle method calls from Flutter
    //             if (call.method == "setText") {
    //                 // Process data sent from Flutter
    //                 val data = call.arguments as? String
    //                 if (data != null) {
    //                     // Handle data
    //                     // Do whatever you need to do with the data
    //                     // For example, print it
    //                     println("Data received from Flutter: $data")
    //                     // Send a result back to Flutter if needed
    //                     result.success("Data received successfully")
    //                 } else {
    //                     result.error("INVALID_DATA", "Data received from Flutter is invalid", null)
    //                 }
    //             } else {
    //                 result.notImplemented()
    //             }
    //         }
    //     }
    // }
    override fun onUpdate(context: Context, appWidgetManager: AppWidgetManager, appWidgetIds: IntArray) {
        for (appWidgetId in appWidgetIds) {
            updateAppWidget(context, appWidgetManager, appWidgetId)
        }

        // val flutterEngine = null
        // flutterEngine?.let {
        //     MethodChannel(null, CHANNEL).setMethodCallHandler { call, result ->
        //         if (call.method == "setText") {
        //             val text = call.argument<String?>("text")
        //             val letter = call.argument<String?>("letter")
        //             val number = call.argument<String?>("number")
                    
        //             // update only if three values exist
        //             if (text == null || letter == null || number == null) {
        //                 result.error("MISSING_ARGUMENT", "Some argument is missing, weird", null)
        //             } else {
        //                 updateWidgetUI(context, appWidgetManager, appWidgetIds, text, letter, number)
        //                 result.success(null)
        //             }
        //         } else {
        //             result.notImplemented()
        //         }
        //     }
        // }
    }

    private fun updateWidgetUI(context: Context, appWidgetManager: AppWidgetManager, appWidgetIds: IntArray, text: String, letter: String, number: String) {
        val views = RemoteViews(context.packageName, R.layout.badge_widget)
        views.setTextViewText(R.id.widget_number, number)
        views.setTextViewText(R.id.widget_letter, letter)
        views.setTextViewText(R.id.widget_text, text)
        appWidgetManager.updateAppWidget(appWidgetIds, views)
        
    }



    override fun onEnabled(context: Context) {
        // Enter relevant functionality for when the first widget is created
    }

    override fun onDisabled(context: Context) {
        // Enter relevant functionality for when the last widget is disabled
    }

    // override fun onReceive(context: Context?, intent: Intent?) {
    //     println("onReceive called by me")
    //     super.onReceive(context, intent)
    // }


}

internal fun updateAppWidget(context: Context, appWidgetManager: AppWidgetManager, appWidgetId: Int) {
    // Construct the RemoteViews object
    val views = RemoteViews(context.packageName, R.layout.badge_widget)
    
    // When the user clicks on any element within the widget, open the widget itself (Not working on my phone?)
    val intent = Intent(context, MainActivity::class.java)

    val pendingIntent = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
        PendingIntent.getActivity(context, 0, intent, PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_MUTABLE)
    } else {
        PendingIntent.getActivity(context, 0, intent, PendingIntent.FLAG_UPDATE_CURRENT)
    }
    views.setOnClickPendingIntent(R.id.circle_button, pendingIntent)
    views.setOnClickPendingIntent(R.id.widget_text, pendingIntent)

    // Get the strings and update the widget elements
    val widgetNumberDefault = context.getString(R.string.widget_number)
    val widgetLetterDefault = context.getString(R.string.widget_letter)
    val widgetTextDefault = context.getString(R.string.widget_text)

    val widgetNumber = widgetData.getString("number", widgetNumberDefault)
    val widgetLetter = widgetData.getString("letter", widgetLetterDefault)
    val widgetText = widgetData.getString("text", widgetTextDefault)

    views.setTextViewText(R.id.widget_number, widgetNumber)
    views.setTextViewText(R.id.widget_letter, widgetLetter)
    views.setTextViewText(R.id.widget_text, widgetText)

    // Instruct the widget manager to update the widget
    appWidgetManager.updateAppWidget(appWidgetId, views)
}