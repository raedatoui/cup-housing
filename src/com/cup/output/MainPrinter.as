package com.cup.output {
	
	import com.cup.model.SubBoroIncomes;
	import com.cup.output.PDFCompositor;
	import com.fonts.ConduitBold;
	import com.fonts.ConduitMedium;
	
	import flash.display.BitmapData;
	import flash.text.Font;
	
	public class MainPrinter {
		public var incomeData:Array = [];
		public var regularFont:Font = new ConduitMedium();
		public var boldFont:Font = new ConduitBold();
		public var testData:BitmapData = new BitmapData(50, 50, false, 0xff0000);
		protected var baseURL:String; 
		
		public function MainPrinter(incomes:Array, baseURL:String) {
			this.incomeData = incomes;
			this.baseURL = baseURL;
		}
		
		public function spoofIncomes():void {
			incomeData[0] = SubBoroIncomes.fromTxt("101		Mott Haven/Hunts Point	13,806	5,590	4,510	1,906	1,850	93	27,756		$23,426");
			incomeData[1] = SubBoroIncomes.fromTxt("102		Morrisania/Belmont	17,910	7,610	5,761	2,570	1,610	59	35,521		$22,542");
			incomeData[2] = SubBoroIncomes.fromTxt("103		Highbridge/South Concourse	13,490	6,589	5,903	2,546	1,216	35	29,778		$27,557");
			incomeData[3] = SubBoroIncomes.fromTxt("104		University Heights/Fordham	15,662	5,767	5,790	1,822	1,361	28	30,430		$22,164");
			incomeData[4] = SubBoroIncomes.fromTxt("105		Kingsbridge Heights/Mosholu	12,848	6,297	6,091	2,991	1,992	130	30,350		$28,676");
			incomeData[5] = SubBoroIncomes.fromTxt("106		Riverdale/Kingsbridge	4,356	4,097	5,015	4,425	5,728	1,391	25,011		$57,709");
			incomeData[6] = SubBoroIncomes.fromTxt("107		Soundview/Parkchester	12,446	7,506	10,851	6,381	3,873	504	41,562		$40,593");
			incomeData[7] = SubBoroIncomes.fromTxt("108		Throgs Neck/ Co-op City	3,816	3,235	5,043	6,821	7,218	428	26,559		$67,059");
			incomeData[8] = SubBoroIncomes.fromTxt("109		Pelham Parkway	6,038	4,691	7,676	5,085	4,631	612	28,732		$49,219");
			incomeData[9] = SubBoroIncomes.fromTxt("110		Williamsbridge/  Baychester	6,379	5,657	6,937	6,699	7,363	752	33,787		$54,503");
			incomeData[10] = SubBoroIncomes.fromTxt("201		Williamsburg/ Greenpoint	9,835	4,870	6,465	2,748	2,859	610	27,387		$35,331");
			incomeData[11] = SubBoroIncomes.fromTxt("202		Brooklyn Heights/Fort Greene	3,878	2,902	3,898	2,773	5,302	2,423	21,176		$61,250");
			incomeData[12] = SubBoroIncomes.fromTxt("203		Bedford Stuyvesant	10,912	4,586	3,760	3,662	3,119	548	26,588		$31,057");
			incomeData[13] = SubBoroIncomes.fromTxt("204		Bushwick	9,831	6,020	4,502	3,406	2,288	72	26,119		$30,445");
			incomeData[14] = SubBoroIncomes.fromTxt("205		East New York/Starrett City	12,752	7,257	6,935	5,853	3,585	307	36,689		$34,808");
			incomeData[15] = SubBoroIncomes.fromTxt("206		Park Slope/Carroll Gardens	2,920	2,278	3,262	3,468	6,975	4,579	23,483		$84,657");
			incomeData[16] = SubBoroIncomes.fromTxt("207		Sunset Park	8,272	5,977	6,446	5,267	5,734	1,006	32,702		$47,836");
			incomeData[17] = SubBoroIncomes.fromTxt("208		North Crown Heights/Prospect Heights	8,320	4,705	6,382	4,614	3,865	934	28,819		$41,809");
			incomeData[18] = SubBoroIncomes.fromTxt("209		South Crown Heights	6,977	5,434	5,243	4,224	3,263	387	25,528		$39,805");
			incomeData[19] = SubBoroIncomes.fromTxt("210		Bay Ridge	4,497	3,709	5,630	5,595	8,371	1,681	29,483		$65,867");
			incomeData[20] = SubBoroIncomes.fromTxt("211		Bensonhurst	9,444	7,506	7,447	7,398	8,142	1,008	40,946		$47,583");
			incomeData[21] = SubBoroIncomes.fromTxt("212		Borough Park	7,438	6,052	7,328	4,292	5,517	886	31,513		$43,326");
			incomeData[22] = SubBoroIncomes.fromTxt("213		Coney Island	6,338	4,036	4,608	4,484	4,999	369	24,834		$46,627");
			incomeData[23] = SubBoroIncomes.fromTxt("214		Flatbush	10,452	6,806	7,302	6,765	5,372	1,351	38,049		$42,753");
			incomeData[24] = SubBoroIncomes.fromTxt("215		Sheepshead Bay/Gravesend	7,848	5,861	6,158	7,492	7,967	1,926	37,252		$56,284");
			incomeData[25] = SubBoroIncomes.fromTxt("216		Brownsville/Ocean Hill	12,005	4,912	4,857	2,899	2,460	265	27,398		$28,048");
			incomeData[26] = SubBoroIncomes.fromTxt("217		East Flatbush	7,700	7,011	6,854	5,575	6,556	688	34,384		$45,850");
			incomeData[27] = SubBoroIncomes.fromTxt("218		Flatlands/Canarsie	5,707	5,843	10,558	11,291	14,058	1,516	48,973		$67,481");
			incomeData[28] = SubBoroIncomes.fromTxt("301		Greenwich Village/Financial District	2,541	1,723	1,966	2,909	6,797	9,930	25,866		$140,900");
			incomeData[29] = SubBoroIncomes.fromTxt("302		Lower East Side/Chinatown	11,052	5,593	5,485	3,763	4,444	1,208	31,545		$35,626");
			incomeData[30] = SubBoroIncomes.fromTxt("303		Chelsea/Clinton/Midtown	2,749	1,983	1,424	2,356	4,057	5,713	18,281		$101,799");
			incomeData[31] = SubBoroIncomes.fromTxt("304		Stuyvesant Town/Turtle-Bay	1,495	1,528	2,506	2,729	7,983	8,826	25,066		$133,888");
			incomeData[32] = SubBoroIncomes.fromTxt("305		Upper West Side	2,972	1,333	4,953	4,792	11,043	20,202	45,295		$168,494");
			incomeData[33] = SubBoroIncomes.fromTxt("306		Upper East Side	1,234	1,628	3,835	3,609	13,328	21,746	45,380		$178,067");
			incomeData[34] = SubBoroIncomes.fromTxt("307		Morningside Heights/Hamilton Heights	7,147	3,386	3,442	2,992	3,163	1,931	22,061		$43,861");
			incomeData[35] = SubBoroIncomes.fromTxt("308		Central Harlem	8,313	4,845	3,686	2,715	2,767	842	23,169		$33,403");
			incomeData[36] = SubBoroIncomes.fromTxt("309		East Harlem	10,949	5,035	4,062	3,032	1,893	930	25,901		$29,208");
			incomeData[37] = SubBoroIncomes.fromTxt("310		Washington Heights/Inwood	15,862	8,324	7,323	5,372	4,139	611	41,631		$31,164");
			incomeData[38] = SubBoroIncomes.fromTxt("401		Astoria	9,745	8,375	8,939	6,648	6,974	917	41,598		$45,400");
			incomeData[39] = SubBoroIncomes.fromTxt("402		Sunnyside/Woodside	5,875	5,913	6,735	5,332	4,578	832	29,266		$44,899");
			incomeData[40] = SubBoroIncomes.fromTxt("403		Jackson Heights	6,724	7,769	8,690	7,314	6,497	512	37,505		$50,140");
			incomeData[41] = SubBoroIncomes.fromTxt("404		Elmhurst/Corona	6,934	7,110	7,966	4,711	4,387	503	31,612		$42,510");
			incomeData[42] = SubBoroIncomes.fromTxt("405		Middle Village/Ridgewood	6,889	7,981	9,620	9,140	9,940	1,285	44,855		$56,172");
			incomeData[43] = SubBoroIncomes.fromTxt("406		Rego Park/Forest Hills	4,069	3,377	3,942	5,995	9,017	2,466	28,867		$73,800");
			incomeData[44] = SubBoroIncomes.fromTxt("407		Flushing/Whitestone	8,608	9,478	12,949	11,795	14,575	2,750	60,156		$59,382");
			incomeData[45] = SubBoroIncomes.fromTxt("408		Hillcrest/Fresh Meadows	3,769	5,850	7,424	7,237	9,372	1,361	35,013		$61,610");
			incomeData[46] = SubBoroIncomes.fromTxt("409		Ozone Park/Woodhaven	5,411	4,865	6,097	7,205	7,606	841	32,025		$60,344");
			incomeData[47] = SubBoroIncomes.fromTxt("410		South Ozone Park/Howard Beach	3,884	4,503	6,466	6,129	8,139	531	29,652		$61,097");
			incomeData[48] = SubBoroIncomes.fromTxt("411		Bayside/Little Neck	2,847	3,350	5,026	5,970	10,397	3,143	30,733		$80,754");
			incomeData[49] = SubBoroIncomes.fromTxt("412		Jamaica	6,365	8,170	12,165	10,187	10,482	878	48,246		$54,508");
			incomeData[50] = SubBoroIncomes.fromTxt("413		Queens Village	3,714	6,235	9,869	11,493	15,865	2,209	49,386		$73,452");
			incomeData[51] = SubBoroIncomes.fromTxt("414		Rockaways	5,725	3,601	4,797	4,781	5,504	1,226	25,634		$54,348");
			incomeData[52] = SubBoroIncomes.fromTxt("501		North Shore	5,959	4,897	6,213	9,421	11,476	2,102	40,068		$67,469");
			incomeData[53] = SubBoroIncomes.fromTxt("502		Mid-Island	4,228	4,834	5,994	7,626	11,921	2,275	36,877		$73,497");
			incomeData[54] = SubBoroIncomes.fromTxt("503		South Shore	2,431	3,100	7,657	9,471	18,882	4,932	46,471		$89,783");
			incomeData[55] = SubBoroIncomes.fromTxt("000		New York City	409,368	287,590	340,443	297,779	362,500	125,289	1,822,967		$51,830");
			incomeData[56] = SubBoroIncomes.fromTxt("100		Bronx	106,751	57,039	63,577	41,246	36,841	4,033	309,487		$36,013");
			incomeData[57] = SubBoroIncomes.fromTxt("200		Brooklyn	145,125	95,765	107,635	91,808	100,434	20,554	561,321		$45,873");
			incomeData[58] = SubBoroIncomes.fromTxt("300		Manhattan	64,314	35,377	38,682	34,271	59,614	71,939	304,196		$70,867");
			incomeData[59] = SubBoroIncomes.fromTxt("400		Queens	80,560	86,578	110,685	103,937	123,332	19,454	524,546		$57,333");
			incomeData[60] = SubBoroIncomes.fromTxt("500		Staten Island	12,617	12,831	19,863	26,518	42,279	9,308	123,416		$78,756");
			
		}
		
		public function printSinglePDF(id:String, r:int, strip1:BitmapData, strip2:BitmapData):void {
			var selectBoroughs:Array = new Array;
			var squareValue:int = 1000;
			
			switch (id) {
				case "100":
					selectBoroughs = ["101", "102", "103", "104", "105", "106", "107", "108", "109", "110"];
					break;
				case "200":
					selectBoroughs = ["201", "202", "203", "204", "205", "206", "207", "208", "209", "210", "211", "212", "213", "214", "215", "216", "217", "218"];
					break;
				case "300":
					selectBoroughs = ["301", "302", "303", "304", "305", "306", "307", "308", "309", "310"];
					break;
				case "400":
					selectBoroughs = ["401", "402", "403", "404", "405", "406", "407", "408", "409", "410", "411", "412", "413", "414"];
					break;
				case "500":
					selectBoroughs = ["501", "502", "503"];
					break;
				
				default:
					selectBoroughs = [id];
					squareValue = 100;
					break;
				
			}
			
			for each (var income:SubBoroIncomes in incomeData) {
				if (id == income.id) {
					trace('found id:', id, income);
					//outputPDF([incomeData[50],incomeData[23]],1997,strip1,strip2);
					outputPDF([income], selectBoroughs, r, strip1, strip2, squareValue);
					return;
				}
			}
		}
		
		public function outputPDF(incomes:Array, sel:Array, r:int, strip1:BitmapData, strip2:BitmapData, squareVal:int):void {
			var mercatorURL:String = baseURL + 'maps/nyc_mercator_all.svg';
			var testPDF:PDFCompositor = new PDFCompositor(mercatorURL, strip1, strip2, incomes, sel, r, squareVal, regularFont, boldFont);
			
		}
	}
}