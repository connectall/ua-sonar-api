/**
 * Convert the data records returned from Sonar to the formatted json that the ConnectALL rest api requires.
 */
package com.connectall.adapter.sonar;

import java.util.Iterator;

import org.json.JSONArray;
import org.json.JSONObject;

/**
 * @author doug
 *
 */
public class SonarToConnectAllJson {

	/**
	 * @param args the json to convert
	 */
	public static void main(String[] args) {

		String appName = args[0];
		String origin = args[1];
		JSONArray records =  null;
		JSONObject result = new JSONObject();
		String input =  convertStreamToString(System.in);// records.getJSONObject(i);
		try {
			JSONObject inputJson = new JSONObject(input);
			records =  inputJson.getJSONArray("issues");
			int recordNum = Integer.parseInt(args[2]);
			if (recordNum >= records.length()) 
				System.exit(-2);
			else {
				JSONObject record = records.getJSONObject(recordNum);
				result.put("appLinkName",  appName);
				result.put("origin", origin);
				JSONObject fields = new JSONObject();
				fields.put("id",  record.getString("key").replaceAll("_", ""));
				fields.put("creationDate",  record.getString("creationDate"));
				fields.put("updateDate", record.getString("updateDate")); // 2019-05-09T09:53:42-04:00
				if (record.has("author"))
					fields.put("author",  record.getString("author")); // 105875
				//fields.put("_URL",  record.getString("web_url"));
				//System.out.println("\n\n@@@@@@@@@@@@@@Keys are: " + record.names() + "@@@@@@@@@@@\n\n");
				for (Iterator i = record.keys(); i.hasNext(); ) {
					String fieldName = (String) i.next();
					String fieldValue = record.getString(fieldName);
//					if (fields.has("field_value_name")) {
//						fieldValue = field.getString("field_value_name");
//					}
					fields.put("Summary",  record.getString("component") + " has a problem with " + record.getJSONArray("tags").getString(1));
					if ("key".equals(fieldName)) {
						fieldName = "id";
						fieldValue = fieldValue.replaceAll("_", ""); // bug found in CA 2.9.7 build with the new connection code
					}
					fields.put(fieldName, fieldValue);
				}
				result.put("fields", fields);
				result.put("appLinkName",  appName);
				result.put("origin",  origin);

				//}
				//System.out.println("}");
			}
		} catch (Exception e) {
			System.err.println("\n\nUnable to parse the json" + input);
			e.printStackTrace();
			System.exit(-1); // parse error
		}
		System.out.println(result.toString());
		System.exit(0);
	}

	static String encode(String s) {
		return s;//encode.URLEncoder.encode(s);//.replace("\"", "&quot;");
	}


	static String convertStreamToString(java.io.InputStream is) {
		java.util.Scanner s = new java.util.Scanner(is).useDelimiter("\\A");
		return s.hasNext() ? s.next() : "";
	}
}
