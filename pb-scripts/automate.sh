#!/bin/bash
secret="$1"
region="$2"
service="$3"
keyID="$4"
url="$5"

echo "[INFO]: Downloading eggs..."

date="`TZ=''"$region"'' date +"%Y%m%dT%k%M%SZ"`"

fullformatdate=$date

semiformatdate=${date%\T*}

# echo $fullformatdate

# echo $semiformatdate

rm -rf get-pbc.creq

touch get-pbc.creq

requesting=${url##*.com}
# echo $requesting
echo -ne "GET
$requesting

host:parabeac-core-plugins-staging.s3.amazonaws.com
x-amz-content-sha256:e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855
x-amz-date:$fullformatdate

host;x-amz-content-sha256;x-amz-date
e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855" >> get-pbc.creq

temp="`openssl dgst -sha256 get-pbc.creq`" 

temp=${temp##*= }

rm -rf get-pbc.sts

touch get-pbc.sts

echo -ne "AWS4-HMAC-SHA256
$fullformatdate
$semiformatdate/$region/s3/aws4_request
$temp" >> get-pbc.sts


function hmac_sha256 {
  key="$1"
  data="$2"
  echo -n "$data" | openssl dgst -sha256 -mac HMAC -macopt "$key" | sed 's/^.* //'
}

# Four-step signing key calculation
dateKey=$(hmac_sha256 key:"AWS4$secret" $semiformatdate)
dateRegionKey=$(hmac_sha256 hexkey:$dateKey $region)
dateRegionServiceKey=$(hmac_sha256 hexkey:$dateRegionKey $service)
signingKey=$(hmac_sha256 hexkey:$dateRegionServiceKey "aws4_request")

tempSignature="`openssl dgst -sha256 \
               -mac HMAC \
               -macopt hexkey:$signingKey \
               get-pbc.sts`"

tempSignature=${tempSignature##*= }

# echo $tempSignature

# filename=${url##*.com/}

curl $url \
     -H "Authorization: AWS4-HMAC-SHA256 \
         Credential=$keyID/$semiformatdate/$region/$service/aws4_request, \
         SignedHeaders=host;x-amz-content-sha256;x-amz-date, \
         Signature=$tempSignature" \
     -H "x-amz-content-sha256: e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855" \
     -H "x-amz-date: $fullformatdate" -s -o tempout.xml



xmllint --format tempout.xml >> clean.xml

files="`sed -n 's:.*<Key>\(.*\)</Key.*:\1:p' clean.xml`"  

for file in ${files[@]}
do
  filename=${file##*\/}
  # echo $file
  bash ../../pb-scripts/auto_download.sh $secret $region $service $keyID $url$file $filename
done

rm -rf get-pbc.creq
rm -rf get-pbc.sts
rm -rf tempout.xml
rm -rf clean.xml

# echo "$filename download complete!"