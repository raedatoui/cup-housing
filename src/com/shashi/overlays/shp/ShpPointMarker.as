package com.shashi.overlays.shp {
import org.vanrijkom.shp.ShpPoint;
import org.vanrijkom.shp.ShpRecord;

public class ShpPointMarker extends ShpMarker {
    public function ShpPointMarker(record:ShpRecord, col:uint = 0xFF0000, rad:Number = 3) {
        super();

        this.id = record.number;
        this.location = (record.shape as ShpPoint).toLocation();

        graphics.beginFill(col);
        graphics.drawCircle(0, 0, rad);
    }

}
}