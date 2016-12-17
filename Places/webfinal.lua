my=require("myapps")

email='jeansebastien.masset@gmail.com'
passwd='fablab'
my.connexion(email,passwd)

lf = my.fichiers()
mc = my.macle()

tableau="<div id='tableau'><table><tr>"

for i= 1,#lf do
    if my.lire_metadata(lf[i]) ~= nil then
    totalmeta = my.lire_metadata(lf[i])
    mesdata =  my.valeur_metadata(totalmeta,'comment')
    lg =  my.valeur_metadata(totalmeta,'longitude')
    la =  my.valeur_metadata(totalmeta,'latitude')
       if mesdata ~= nil then
       tableau = tableau .."<th class='tab_img'><a href='#' onclick='initMap("..lg..","..la..")'><img src='http://prototypel1.irisa.fr/files/"..mc.."/thumb_"..lf[i].."'></a></th>"
       end
    end
end

tableau=tableau.."</tr><tr>"

for i= 1,#lf do
    if my.lire_metadata(lf[i]) ~= nil then
    totalmeta = my.lire_metadata(lf[i])
    mesdata =  my.valeur_metadata(totalmeta,'comment')
       if mesdata ~= nil then
       titre=mesdata['Titre']
          if titre ~= nil then
          tableau=tableau.."<th>"..titre.."</th>"
          else
          tableau=tableau.."<th>Pas de titre :(</th>"
          end
       end
    end
end

tableau=tableau.."</tr></table></div>"


part1=[[
<!DOCTYPE html>
<html>
  <head>
  <meta charset="utf-8">
  <title>PixSearch - Places</title>
  <style>
     html, body {
             height: 100%;
             margin: 0;
             padding: 0;
             font-family: Verdana, Geneva, sans-serif;
             font-size: 10px;
             color: #3D180A;
             background-color: #26404C;
                 }
                                                                        
      #map {
              height: 100%;
              width: 100%;
           }
                                                                        
      #tableau {
              width: 100%;
              height: 120px;
              overflow: auto;
              overflow-y: hidden;
              background-color: #A68D78;
                }

       .tab_img img {
              width: 80px;
		    }
   </style>
   <script>
var map;
var infoWindow;
var service;

function initMap(la,lg) {
  map = new google.maps.Map(document.getElementById('map'), {
    center: {lat: la,lng: lg},
    zoom: 15,
    styles: [{
      stylers: [{ visibility: 'simplified' }]
    }, {
      elementType: 'labels',
      stylers: [{ visibility: 'off' }]
    }]
  });
  infoWindow = new google.maps.InfoWindow();
  service = new google.maps.places.PlacesService(map);

  // The idle event is a debounced event, so we can query & listen without
  // throwing too many requests at the server.
  map.addListener('idle', performSearch);
}

function performSearch() {
  var request = {
    bounds: map.getBounds(),
    types:'store'
  };
  service.radarSearch(request, callback);
}
function callback(results, status) {
  if (status !== google.maps.places.PlacesServiceStatus.OK) {
    console.error(status);
    return;
  }
  for (var i = 0, result; result = results[i]; i++) {
    addMarker(result);
  }
}

function addMarker(place) {
  var marker = new google.maps.Marker({
    map: map,
    position: place.geometry.location,
    icon: {
      url: 'http://maps.gstatic.com/mapfiles/circle.png',
      anchor: new google.maps.Point(10, 10),
      scaledSize: new google.maps.Size(10, 17)
    }

 });

  google.maps.event.addListener(marker, 'click', function() {
    service.getDetails(place, function(result, status) {
      if (status !== google.maps.places.PlacesServiceStatus.OK) {
        console.error(status);
	return;
      }
      infoWindow.setContent(result.name);
      infoWindow.open(map, marker);
    });
  });
}

    </script>
  </head>
  <body>]]

part3 = [[
    <div id="map"></div>
    <script src="https://maps.googleapis.com/maps/api/js?key=AIzaSyBip2lL-N4r\
OZGo1rd03sSvv6yL5crxKF0&callback=initMap&libraries=places&language=fr,visu\
alization" async defer></script>
  </body>
</html>]]


page=part1..tableau..part3

print(page)

my.publierpage_html(page)

my.deconnexion()
