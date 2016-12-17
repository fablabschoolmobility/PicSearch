my=require("myapps")

email='jeansebastien.masset@gmail.com'
passwd='fablab'
my.connexion(email,passwd)

lf = my.fichiers()
mc = my.macle()

-- Je commence par générer le tableau qui va contenir les photos et leurs titres. Je créé une variable "tableau" que je vais 
-- compléter progressivement. 
 
tableau="<div id='tableau'><table><tr>" -- J'ouvre ma div, mon tableau et ma premiere ligne

-- La premiére boucle correspond à la premiere ligne du tableau qui contient les images. 

for i= 1,#lf do -- Créer un compteur qui regarde tous les fichiers du dossier
    if my.lire_metadata(lf[i]) ~= nil then -- Si le fichier a des metadata
    totalmeta = my.lire_metadata(lf[i]) -- Créer une variable qui contient les metadata
    lg =  my.valeur_metadata(totalmeta,'longitude') -- Créer une variable qui contient la longitude
    la =  my.valeur_metadata(totalmeta,'latitude') -- Créer une variable qui contient la latitude
    -- Enfin, je génére une cellule qui contient ma balise img. 
    -- J'ai besoin de d'utiliser plusieurs informations contenues dans des variables :
    -- Dans la balise img, j'ai un evenement onclick qui déclenche l'affichage de la carte, et qui doit récupérer la longitude et la latitude correspondant à l'image traitée par la boucle.
    -- Dans l'url de l'image, il y a la clé et le nom du fichier image. 
    tableau = tableau .."<th class='tab_img'><a href='#' onclick='initMap("..lg..","..la..")'><img src='http://prototypel1.irisa.fr/files/"..mc.."/thumb_"..lf[i].."'></a></th>"
    end
end

-- Je ferme la ligne des images et j'ouvre celle des titres

tableau=tableau.."</tr><tr>"

for i= 1,#lf do -- Compteur
    if my.lire_metadata(lf[i]) ~= nil then -- Si le fichier a des metadata 
    totalmeta = my.lire_metadata(lf[i]) -- Créer une variable qui contient les metadata
    mesdata =  my.valeur_metadata(totalmeta,'comment') -- Créer une variable qui contient les metadata personnalisées
       if mesdata ~= nil then  -- Si il y a quelque chose dans les metadata personnalisée
       titre=mesdata['Titre'] -- Créer une variable contenant le titre
          if titre ~= nil then  -- Si il y a quelque chose dans la variable titre
          tableau=tableau.."<th>"..titre.."</th>" -- Créer une cellule dans le tableau et afficher le titre dedans
          else -- Sinon 
          tableau=tableau.."<th>Pas de titre :(</th>" -- Créer une cellule dans le tableau et y écrire la phrase "pas de titre"
          end
       end
    end
end

-- Je ferme ma ligne, mon tableau et ma div

tableau=tableau.."</tr></table></div>"

-- Je créé une variable qui contient le début de ma page

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

-- Je créé une variable qui contient la fin de ma page

part3 = [[
    <div id="map"></div>
    <script src="https://maps.googleapis.com/maps/api/js?key=AIzaSyBip2lL-N4r\
OZGo1rd03sSvv6yL5crxKF0&callback=initMap&libraries=places&language=fr,visu\
alization" async defer></script>
  </body>
</html>]]

-- Je créé une variable qui contient toute ma page en concaténant les trois variables qui correspondent aux différentes parties de ma page

page=part1..tableau..part3

-- J'affiche
print(page)

-- Je créé le fichier HTML sur le serveur
my.publierpage_html(page)

my.deconnexion()
