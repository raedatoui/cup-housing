/*
 * $Id: MarkerEvent.as 647 2008-08-25 23:38:15Z tom $
 */

package com.modestmaps.events {
import flash.events.Event;

import com.modestmaps.geo.Location;

import flash.display.DisplayObject;

public class MarkerEvent extends Event {
    public static const ROLL_OVER:String = 'markerRollOver';
    public static const ROLL_OUT:String = 'markerRollOut';
    public static const CLICK:String = 'markerClick';

    protected var _marker:DisplayObject;
    protected var _location:Location;

    public function MarkerEvent(type:String, marker:DisplayObject, location:Location, bubbles:Boolean = true, cancelable:Boolean = false) {
        super(type, bubbles, cancelable);
        _marker = marker;
        _location = location;
    }

    public function get marker():DisplayObject {
        return _marker;
    }

    public function get location():Location {
        return _location;
    }
}
}