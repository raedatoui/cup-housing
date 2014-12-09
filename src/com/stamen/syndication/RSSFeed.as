package com.stamen.syndication {
import com.stamen.utils.DateUtils;

public class RSSFeed extends XMLWrapper {
    public function RSSFeed(xml:XML) {
        var name:Object = xml.localName();
        var valid:Boolean = true;
        if (name != 'channel') {
            var feedNodes:XMLList = xml..channel;
            if (feedNodes.length() == 1) {
                xml = feedNodes[0];
            }
            else {
                valid = false;
            }
        }
        if (valid) {
            super(xml);
        }
        else {
            throw new Error("Unable to find a <feed> element in the provided XML");
        }
    }

    public function get title():String {
        return getText('title');
    }

    public function get pubDate():Date {
        return DateUtils.parseRFC822(getText('pubDate'));
    }

    public function get items():Array {
        if (!_xml) return new Array();

        var items:Array = new Array();
        for each (var itemNode:XML in _xml..item) {
            var item:RSSItem = new RSSItem(itemNode);
            items.push(item);
        }
        return items;
    }
}
}