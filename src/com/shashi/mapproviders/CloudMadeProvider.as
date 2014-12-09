package com.shashi.mapproviders {
import com.modestmaps.core.Coordinate;
import com.modestmaps.mapproviders.OpenStreetMapProvider;

public class CloudMadeProvider extends OpenStreetMapProvider {
    public static const PALE_DAWN:int = 998;
    public static const MIDNIGHT_COMMANDER:int = 999;
    public static const FRESH:int = 997;
    protected var apikey:String = 'BC9A493B41014CAABB98F0471D759707';
    // for diametunim.com
    '692297d90d85591a93902f1086b951d8';
    // for stamen.com
    '1a914755a77758e49e19a26e799268b7';
    protected var styleID:int = 998;

    public function CloudMadeProvider(style:int = 998, minZoom:int = MIN_ZOOM, maxZoom:int = MAX_ZOOM) {
        styleID = style;
        super(minZoom, maxZoom);
    }

    override public function toString():String {
        return "CLOUDMADE_MAP";
    }

    override public function getTileUrls(coord:Coordinate):Array {
        var sourceCoord:Coordinate = sourceCoordinate(coord);
        return ['http://b.tile.cloudmade.com/' + apikey + '/' + styleID + '/256/' + (sourceCoord.zoom) + '/' + (sourceCoord.column) + '/' + (sourceCoord.row) + '.png'];
    }
}
}