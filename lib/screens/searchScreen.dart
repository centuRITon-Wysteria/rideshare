
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rideshare/Assistants/requestAssistant.dart';
import 'package:rideshare/DataHandler/appData.dart';
import 'package:rideshare/models/address.dart';
import 'package:rideshare/models/placePredictions.dart';
import 'package:rideshare/utils/config.dart';
import 'package:rideshare/widgets/progressDialog.dart';

import '../widgets/Divider.dart';


class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen>
{
  TextEditingController pickUpTextEditingController = TextEditingController();
  TextEditingController dropOffTextEditingController = TextEditingController();
  List<PlacePredictions> placePredictionList = [];

  @override
  Widget build(BuildContext context)
  {
    String placeAddress = Provider.of<AppData>(context).pickUpLocation.placeName ?? "";
    pickUpTextEditingController.text = placeAddress;

    return Scaffold(
      body: Column(
        children: [
          Container(
            height: 215.0,
            decoration: const BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black,
                  blurRadius: 6.0,
                  spreadRadius: 0.5,
                  offset: Offset(0.7, 0.7),
                ),
              ],
            ),
            
            child: Padding(
              padding: const EdgeInsets.only(left: 25.0, top: 25.0, right: 25.0, bottom: 20.0),
              child: Column(
                children: [

                  const SizedBox(height: 25.0),
                  Stack(
                    children: [
                      GestureDetector(
                        onTap:()
                        {
                          Navigator.pop(context);
                        },
                        child: const Icon(
                            Icons.arrow_back
                        ),
                      ),

                      const Center(
                        child: Text("Set Drop Off", style: TextStyle(fontSize: 18.0, fontFamily: "Brand Bold"),),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16.0),

                  Row(
                    children: [
                      Image.asset("images/pickicon.png", height: 16.0, width: 16.0,),

                      const SizedBox(width: 18.0,),

                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(3.0),
                            child: TextField(
                              controller: pickUpTextEditingController,
                              decoration: InputDecoration(
                                hintText: "PickUp Location",
                                fillColor: Colors.grey[200],
                                filled: true,
                                border: InputBorder.none,
                                isDense: true,
                                contentPadding: const EdgeInsets.only(left: 11.0, top: 8.0, bottom: 8.0),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 10.0),

                  Row(
                    children: [
                      Image.asset("images/desticon.png", height: 16.0, width: 16.0,),

                      const SizedBox(width: 18.0,),

                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(3.0),
                            child: TextField(
                              onChanged: (val)
                              {
                                findPlace(val);
                              },
                              controller: dropOffTextEditingController,
                              decoration: InputDecoration(
                                hintText: "Where to?",
                                fillColor: Colors.grey[200],
                                filled: true,
                                border: InputBorder.none,
                                isDense: true,
                                contentPadding: const EdgeInsets.only(left: 11.0, top: 8.0, bottom: 8.0),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                ],
              ),
            ),
          ),
          
          //tile for predictions
          const SizedBox(height: 10.0,),
          (placePredictionList.length > 0)
              ? Expanded(
                child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                    child: ListView.separated(
                      padding: const EdgeInsets.all(0.0),
                      itemBuilder: (context, index)
                      {
                        return PredictionTile(placePredictions: placePredictionList[index],);
                      },
                      separatorBuilder: (BuildContext context, int index) => DividerWidget(),
                      itemCount: placePredictionList.length,
                      shrinkWrap: true,
                      physics: const ClampingScrollPhysics(),
                    ),
                  ),
              )
              : Container(),
        ],
      ),
    );
  }

  void findPlace(String placeName) async
  {
    if(placeName.length > 1)
    {
      String autoCompleteUrl = "https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$placeName&key=$mapKey&sessiontoken=1234567890&components=country:IND";

      var res = await RequestAssistant.getRequest(autoCompleteUrl);

      if(res == "failed")
      {
        return;
      }

      if(res["status"] == "OK")
      {
        var predictions = res["predictions"];

        var placesList = (predictions as List).map((e) => PlacePredictions.fromJson(e)).toList();

        setState(() {
          placePredictionList = placesList;
        });
      }
    }
  }
}


class PredictionTile extends StatelessWidget 
{
  final PlacePredictions placePredictions;

  PredictionTile({Key? key, required this.placePredictions}) : super(key: key);
  
  @override
  Widget build(BuildContext context) 
  {
    return ElevatedButton(
      onPressed: ()
      {
        getPlaceAddressDetails(placePredictions.place_id, context);
      },
      child: Container(
        child: Column(
          children: [
            const SizedBox(width: 10.0,),
            Row(
              children: [
                const Icon(Icons.add_location),
                const SizedBox(width: 14.0,),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 8.0,),
                      Text(placePredictions.main_text, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 16.0),),
                      const SizedBox(height: 2.0,),
                      Text(placePredictions.secondary_text, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 12.0, color: Colors.grey),),
                      const SizedBox(height: 8.0,),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(width: 10.0,),
          ],
        ),
      ),
    );
  }

  void getPlaceAddressDetails(String placeId, context) async
  {
    showDialog(
      context: context,
      builder: (BuildContext context) => ProgressDialog(message: "Setting Dropoff, Please wait...",)
    );

    String placeDetailsUrl = "https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&key=$mapKey";
    
    var res = await RequestAssistant.getRequest(placeDetailsUrl);

    Navigator.pop(context);

    if(res == "failed")
    {
      return;
    }

    if(res["status"] == "OK")
    {
      Address address = Address(placeFormattedAddress: '', placeName:res["result"]["name"], placeId: placeId, latitude: res["result"]["geometry"]["location"]["lat"], longitude: res["result"]["geometry"]["location"]["lng"]);
      address.placeName = res["result"]["name"];
      address.placeId = placeId;
      address.latitude = res["result"]["geometry"]["location"]["lat"];
      address.longitude = res["result"]["geometry"]["location"]["lng"];

      Provider.of<AppData>(context, listen: false).updateDropOffLocationAddress(address);
      print("This is Drop Off Location :: ");

      print(address.placeName);

      Navigator.pop(context, "obtainDirection");
    }
  }
}
