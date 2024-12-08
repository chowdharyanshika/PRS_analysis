import requests
import json
import urllib.request
from optparse import OptionParser



def get_scoring_files( pgs_id):
    BASE_URL = "https://www.pgscatalog.org/rest/"
    endpoint = "score/"
    response = requests.get(BASE_URL + endpoint + pgs_id)
    print("response")
    print(response)

    if response.status_code == 200:
        data = response.json()
        return data
    else:
        print(f"Error: {response.status_code}")
        return None



def download_file_urllib(ftp_url, output_file):
    try:
        urllib.request.urlretrieve(ftp_url, output_file)
        print(f"File downloaded as {output_file}")
    except urllib.error.URLError as e:
        print(f"URL Error: {e.reason}")
    except urllib.error.HTTPError as e:
        print(f"HTTP Error {e.code}: {e.reason}")
    except Exception as e:
        print(f"An unexpected error occurred: {e}")

def main():
    BASE_URL = "https://www.pgscatalog.org/rest/"

    # Initialize the parser
    parser = OptionParser()

    # Add options
    parser.add_option("-i", "--id", dest="pgs_id", help="Input PGS ID")
    parser.add_option("-v", "--verbose", action="store_true", dest="verbose", default=False, help="Enable verbose output")/

    # Parse command-line arguments
    (options, args) = parser.parse_args()

    # Use parsed options
    if options.verbose:
        print("Verbose mode enabled")
    if options.pgs_id:
        print(f"Processing file: {options.pgs_id}")
    else:
        print("No id provided. Use -id to specify a file.")

    pgs_data = get_scoring_files(options.pgs_id)

    print(pgs_data)
    ftp_url = pgs_data["ftp_scoring_file"]
    output_file = "/Users/anshika.chowdhary/" + options.pgs_id

    download_file_urllib(ftp_url, output_file)

if __name__ == "__main__":
    main()
