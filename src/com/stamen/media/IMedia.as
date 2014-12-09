package com.stamen.media {
import flash.geom.Point;
import flash.net.URLRequest;

public interface IMedia {
    function get id():String;

    function get title():String;

    function get href():URLRequest;

    function get media():String;

    function get label():String;

    function get authorName():String;

    function getImageURL(size:String = null, ...rest):URLRequest;

    function getVideoURL(autoPlay:Boolean = true):URLRequest;

    function getDimensions(size:String = null, defaultAspectRatio:Number = 0):Point;
}
}