#!/usr/bin/perl
use strict;
use warnings;
use utf8;
use Encode;
use JSON;
use LWP::UserAgent;

my $google_api_key = 'AIzaSyBc5r7A9lecIpRLsXczcJRG0py_xYhsB2k';
my $user_id = '103792214056489833385';
my $api_base_url = "https://www.googleapis.com/plus/v1/people/$user_id";

my $url = "$api_base_url/activities/public?alt=json&maxResults=100&key=$google_api_key";
while(1){

  my $nextPageToken = &getjson($url);
#print"nextPageToken : [$nextPageToken]\n";
  if($nextPageToken eq''){last}
  $url = "$api_base_url/activities/public?alt=json&maxResults=100&pageToken=$nextPageToken&key=$google_api_key";

}
exit(0);

sub getjson(){
  my $url = $_[0];
  my $ua = LWP::UserAgent->new;
  my $req = HTTP::Request->new('GET', $url);
  $ua->agent();
  $req->referer();
  my $response = $ua->request($req);

  unless ($response->is_success) {
    print 'Request: ' . $url, "\n";
    warn 'Failed to request to WEB API.', "\n";
  }else{
#    print 'Request: ' . $url, "\n";
    print $response->content;
    my $result = JSON->new->utf8(0)->decode(decode_utf8($response->content));
    if(defined($result->{nextPageToken})){return($result->{nextPageToken})}
  }

}

