package spire_web_quickstart.controllers

import std.time.*
import std.random.*
import std.collection.*
import spire_web_mvc.*
import spire_web_hosting.*
import stdx.encoding.json.*
import spire_web_authorization.*
import spire_extensions_logging.*
import stdx.serialization.serialization.*
import std.unittest.prop_test.RandomSource

@Route["api/[controller]"]
public class WeatherForecastController <: Controller {
    private let summaries = ["Freezing", "Bracing", "Chilly", "Cool", "Mild", "Warm", "Balmy", "Hot", "Sweltering",
        "Scorching"]
   
    @HttpGet
    public func get() {
        let rand = Random()
       
        let list = 1..6 |> map{i => WeatherForecast(
            date: DateTime.now().addDays(i), 
            temperatureC: rand.nextInt64(), 
            summary: summaries[rand.nextInt64(summaries.size)])} |> collectArrayList
        //return json(list)
        return json(WeatherForecast(date: DateTime.now(), summary: summaries[rand.nextInt64(summaries.size)]) )
    }
}

class WeatherForecast <: Serializable<WeatherForecast> {

    WeatherForecast(var date!: ?DateTime = None, var summary!: ?String = None, var temperatureC!: ?Int64 = None) {

    }

    public prop temperatureF: ?Int64 {
        get() {
            if (let Some(temperatureC) <- temperatureC) {
                return 32 + Int64(Float64(temperatureC) / 0.5556)
            }
            return None
        }
    }



    public static func deserialize(dm: DataModel): WeatherForecast {
        let model = WeatherForecast()
        if (let dms: DataModelStruct <- dm) {
            if (let date: DataModelString <- dms.get('date')) {
                model.date = DateTime.parse(date.getValue())
            }
          
            if (let summary: DataModelString <- dms.get('summary')) {
                model.summary = summary.getValue()
            }
          
            if (let temperatureC: DataModelInt <- dms.get('temperatureC')) {
                model.temperatureC = temperatureC.getValue()
            }
        }
        return model
    }

    public func serialize(): DataModel {
        let dms = DataModelStruct()
        if (let Some(date) <- date) {
            dms.add(Field("date", DataModelString(date.toString())))
        }
        
        if (let Some(summary) <- summary) {
            dms.add(Field("summary", DataModelString(summary)))
        }
        
        if (let Some(temperatureC) <- temperatureC) {
            dms.add(Field("temperatureC", DataModelInt(temperatureC)))
        }

        if (let Some(temperatureF) <- temperatureF) {
            dms.add(Field("temperatureF", DataModelInt(temperatureF)))
        }
        return dms
    }
}
