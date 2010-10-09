import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.net.URL;
import java.net.URLConnection;

public class CopyURL {
	static public boolean get(String urlString, String cachefile)
			throws IOException {
		
//		System.err.format("Getting URL %s (cache file %s)%n", urlString, cachefile);
		
		File cache = new File(cachefile);

		if (cache.exists() && cache.isFile()) {
//			System.err.println("File already exists");
			return true;
		}
		
		// Create cache directory if needed
		final File pdir = cache.getParentFile();
		if (!pdir.isDirectory() && !pdir.mkdirs())
			return false;
		
		// Copy
//		System.err.println("Copying");
		byte[] buffer = new byte[8192];
		URL url = new URL(urlString);
		URLConnection connection = url.openConnection();
		InputStream is = connection.getInputStream();

		FileOutputStream out = new FileOutputStream(cache);
		int read;
		while ((read = is.read(buffer, 0, buffer.length)) >= 0)
			if (read > 0)
				out.write(buffer, 0, read);

		// Close
		out.close();
		is.close();
		return true;
	}

}
