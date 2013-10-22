<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<script type="text/javascript">document.documentElement.className += " js"</script>
<meta name="keywords" content="Velti mobile, Velti advertising, Velti marketing, Velti mobile marketing, Velti mobile marketing and advertising" />
<meta name="description" content="Advertising products and services via SMS, mobile web, mobile apps" />
<link rel="stylesheet" type="text/css" href="css/global.css" />
<link rel="shortcut icon" href="favicon/favicon.ico" type="image/x-icon" />
<link rel="stylesheet" href="js/fancybox/jquery.fancybox-1.3.4.css" type="text/css" media="screen" />
<!--[if lte IE 7]><link rel="stylesheet" type="text/css" href="css/ie.css" /><![endif]-->
<!--[if IE]><script src="js/html5.js"></script><![endif]-->
<!-- <script type="text/javascript" src="js/jquery.js"></script> -->


<script src="jscript/jquery-1.7.2.js"></script>
<script type="text/javascript" src="js/jquery.tools.js"></script>
<script type="text/javascript" src="js/jquery.velti.js"></script>
<script type="text/javascript" src="js/fancybox/jquery.mousewheel-3.0.4.pack.js"></script>
<script type="text/javascript" src="js/fancybox/jquery.fancybox-1.3.4.js"></script>

<script type="text/javascript" src="js/jquery.validate_byid.js"></script>
<script type="text/javascript" src="js/popup.js"></script>
<script src="jscript/jquery.bxSlider.js"></script>
<title>Velti | Velti, Mobile Marketing and Mobile Advertising</title>
<script type="text/javascript">
var _gaq = _gaq || [];
_gaq.push(['_setAccount', 'UA-28963572-1']);
_gaq.push(['_trackPageview']);
(function() {
var ga = document.createElement('script'); ga.type = 'text/javascript'; ga.async = true;
ga.src = ('https:' == document.location.protocol ? 'https://ssl' : 'http://www') + '.google-analytics.com/ga.js';
var s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(ga, s);
})();
</script>

<script type="text/javascript">
//setup the slider
	$(document).ready(function(){
		$('#slider').bxSlider({
			pause: 5000,
			auto: true,
			pager: true,
			autoStart: true,
			randomStart: false
		});
	});	
</script>
<script type="text/javascript">
//setup the fancybox to play you tube video
	$(document).ready(function() {
		
		$('a#playit').click(function() {
			$.fancybox({
				'type' : 'iframe',
				// hide the related video suggestions and autoplay the video
				'href' : this.href.replace(new RegExp('watch\\?v=', 'i'), 'embed/') + '?rel=0&autoplay=1&modestbranding=1&showinfo=0&autohide=1&ap=%2526fmt%3D22',
				'overlayShow' : true,
				'centerOnScroll' : true,
				'speedIn' : 100,
				'speedOut' : 50,
				'width' : 640,
				'height' : 400
			});
    		return false;
		});		
	});
</script>
</head>

<body>
<div id="minWidth">
  	<div class="outer">
		<header class="top">
			<div class="logo">
				<a href="index.html"><i class="p"></i>velti</a>
			</div>
			<nav class="b-navigation">
				<ul>

					<li><a href="marketers.html">Marketers<br />&amp; AGENCIES</a></li>
					<li><a href="publishers.html">Publishers &amp; MEDIA</a></li>
					<li><a href="operators.html">mobile OPERATORS</a></li>
					<li><a href="technology.html">technology</a></li>
					<li><a href="resources.html">resources</a></li>

					<li><a href="http://investors.velti.com/">investors</a></li>	            	       
				</ul>
			</nav>
		</header>
    	<section class="b-mainslider">
			
			<div class="mainslider-area">
				<ul class="mainslider-area__ul" id="slider">
                      <li class="ms-annnounce__li">
                     	<section class="overlayWhite"> &nbsp;</section>
						<article>
							<section class="sliderLeft">
							   <h2>This Is Marketing, Mobilized</h2>
								<p>WATCH HOW VELTI CONNECTS BRANDS TO CONSUMERS.</p>
								<!--span class="learnmorebtnlast">
									<a href="marketers.html" title="LEARN MORE">LEARN MORE</a>
								</span-->
							</section>	
							 <section class="sliderRight">
								<a id="playit" title="video" href="http://www.youtube.com/watch?v=m7j-UALkusk"><img  align="right" src="img/velti-video.png" width="548" height="378" alt="Velti Mobile Marketing" title="Velti Mobile Marketing"></a>
							 </section>
						</article>
					 </li>
					 <li class="ms-annnounce__li">
                     	<section class="overlayWhite"> &nbsp;</section>
                         	<article>
                            	<section class="sliderLeft">
                             	   <h2>Reinventing marketing for the mobile era</h2>
                                	<p>Innovative tools for Marketers. Services when you need them. Global leadership in mobile.</p>
                                 	<span class="learnmorebtnlast">
                                 		<a href="marketers.html" title="LEARN MORE">LEARN MORE</a>
                             		</span>

                                </section>	
                                 <section class="sliderRight">
                                 	<img  align="right" src="img/velti_mobile_marketing.png" width="510" height="377" alt="Velti Mobile Marketing" title="Velti Mobile Marketing">
                                 </section>
                            </article>
					 </li>
					 
					 <li class="ms-annnounce__li">
                    		 <section class="overlayWhite"> &nbsp;</section>

                         	<article>
                            	<section class="sliderLeft">
                             	   <h2>Discover mGage</h2>
                                	<p>Innovative Mobile Marketing Platform. Built for Marketers & Agencies. Data-driven Visibility.</p>
                                 	<span class="learnmorebtn">
                                 		<a href="technology.html" title="LEARN MORE">LEARN MORE</a>
                             		</span>

                                </section>	
                                 <section class="sliderRight">
                                 	<img align="right" src="img/carousel_mgage_slide31.png" alt="Banner">
                                 </section>
                            </article>
					 </li>
					 <li class="ms-annnounce__li">
                    		 <section class="overlayWhite"> &nbsp;</section>
                         	<article>

                            	<section class="sliderLeft">
                             	   <h2>Reduce customer churn</h2>
                                	<p>Large scale campaigns that drive loyalty.</p>

                                 	<span class="learnmorebtn">
                                 		<a href="operators.html" title="LEARN MORE">LEARN MORE</a>
                             		</span>
                                </section>	
                                 <section class="sliderRight">

                                 	<img align="right" src="img/slide_05_2.png" alt="Banner">
                                 </section>
                            </article>
					 </li>
                     <li class="ms-annnounce__li">
                    		 <section class="overlayWhite"> &nbsp;</section>
                         	<article>
                            	<section class="sliderLeft">

                             	   <h2>Connecting the best ads with the best apps</h2>
                                	<p>THE ONLY REAL-TIME BIDDING MOBILE 
AD EXCHANGE FOR DEVELOPERS AND ADVERTISERS</p>
                                 	<span class="learnmorebtn">
                                 		<a href="publishers.html" title="LEARN MORE">LEARN MORE</a>
                             		</span>
                                </section>	
                                 <section class="sliderRight">
                                 	<img align="right" src="img/slide_03_v03.png" width="483" height="378" alt="Banner">

                                 </section>
                            </article>
					 </li>
             </ul>
                <section class="ltsnews">	
					<section class="latestheading">latest News</section>
						<section class="latestnewsdata">
                        	<p><a href="latestnews.html">Velti Announces Solid First Quarter 2012 Financial Results: 75% Year on Year Revenue and 260% EBITDA</a></p>

							<span>5/15/2012 </span>
						</section>
				</section>
            </div>
          </section>
		<section class="middle_data pdgTop45">
            <section class="box1">
               <h1>Massive Mobile Reach</h1>

               <span> Reach customers before your competitors</span>
               <p>Over 1000 global brands, agencies, and mobile operators in more than 68 countries trust Velti as their partner in mobile. We can help you develop marketing strategies that incorporate new ways of reaching customers and give you access to important data facts that optimize your campaigns.</p>
               <a href="marketers.html" class="more">Learn more &gt;</a>
            </section>
            <section class="box1">
                <h1>Advanced Technology</h1>

                <span> Self-service platform for mobile marketing</span>
                <p>Introducing mGage. Our rich set of innovative tools built on best practices and 12+ years of mobile execution. The platform enables marketers and agencies to change the way brands reach and interact with their consumers. <br><br></p>
                <a href="technology.html" class="more">Learn more &gt;</a>
            </section>        
            <section class="box1 box2">
        	<h1>Deep Experience</h1>
       		<span>Expert services help with time-to-market</span>

	   		<p>Introducing Velti Services. Our team of experts works closely with you to deliver mobile solutions and capture data that drive and intensify connections to your customers and audiences around the world.</p>
        </section>
        </section>
		<section class="b-middle b-middle2 ">
			<section class="homefooter">
                <section class="box3">
                    <h1>Join the Conversation</h1>
                    <section class="newslatest">

                         <p> <a href="http://blog.velti.com/velti-cmo-krishna-subramanian-on-fox-news/">Velti CMO, Krishna Subramanian, on Fox News!</a> <p>Kicking off Apple's annual Worldwide Developers Conference (WWDC) this week, Fox News interviewed our very own CMO, Krishna Subramanian, this past Monday&hellip;<span>June 13, 2012</span></p>
                   </section>
                    <section class="newslatest">
                   <p><a href="http://blog.velti.com/microsoft-throws-cold-water-on-online-advertisers-by-activating-do-not-track/">Microsoft Throws Cold Water on Online Advertisers by Activating 'Do Not Track'</a>

                   <p>On May 31, Microsoft announced that they will ship the next version of Internet Explorer with the Do Not Track (DNT) option turned on by default&hellip;<span>June 12, 2012</span></p>
                   </section>
				   <section class="readblog">Read our blog <a href="http://blog.velti.com/" title="The Mobile Base">The Mobile Base</a></section>
                </section>
                <section class="box3">
                    <h1>See Us At</h1>
					
					<section class="newslatest">
						<p><a href="press-events.html">2nd Annual MMA CEO/CMO Summit</a><br></p>
						<p class="smltxt">Casa De Campo, Dominican Republic / July 15-17<br>
						Velti is a sponsor and speaker.<br>
								Speaker: Alex Moukas, CEO<br>
								Topic: Mobile IPOs: How to do it!, July 16&hellip;
						 </p>
					</section>
					<section class="newslatest">
						<p><a href="press-events.html">Cannes Lions International Festival of Creativity</a><br></p>
						<p class="smltxt">Cannes, France / June 17-23<br>
						Velti is a sponsor, speaker and exhibitor.<br>
								Session: Mobile Day Speaking Panel <br>
								Topic: Deconstructing Mobile, June 19, 3:30 - 4:30PM&hellip;
						 </p>
					</section>
					<section class="newslatest">
						<p><a href="press-events.html">Communicasia 2012</a><br></p>
						<p class="smltxt">Singapore / June 19-22<br>
						Session: Customer Experience Management &amp; Augmented Reality, June 20 at  4:40 PM&hellip;
						 </p>
					</section>
					<!--section class="newslatest">
						<p><a href="press-events.html">Mobile Asia Expo</a><br></p>
						<p class="smltxt">Shanghai, China / June 20-22<br>
							Velti is a speaker<br>
								Session: Optimizing Mobile Advertising in Asia, June 21, 3:45 - 5:00 PM&hellip;  
						 </p>
					</section-->
					
					
				</section>
                
                <section class="box3">
                    <h1>In the News</h1>
                         <section class="newslatest">

                   <p style="padding-bottom:3px;">
                   <a href="http://techcrunch.com/2012/06/12/velti-mobile-ad-report-may/">Velti Mobile Ad Report: iOS Pulls Way Ahead of Android, iPod Touch Beating iPad</a> 
                   <p>TechCrunch's Anthony Ha covers our latest data report for mobile advertising. <br>
					<span>June 12, 2012</span>
                    </p><br><br>

                   <p><a href="http://www.businessinsider.com/the-most-important-people-in-mobile-advertising-2012-6?op=1">Meet The 18 Most Important People In Mobile Advertising</a><br>Business Insider shares its Mobile Power List for 2012--and Velti CEO, Alex Moukas, makes the list! <br>
					<span>June 11, 2012</span></p>
                    <!-- P TAG MISSING-->
                    <section class="sociallink">
                     <a href="http://www.facebook.com/velti" class="facebook" title="Facebook"><img src="img/facebook.png"  width="26"
                      height="26" alt="Facebook"></a>
                     <a href="https://twitter.com/#!/veltimobile" class="twitter" title="Twitter"><img src="img/twitter.png" width="27" height="26" alt="Twitter"></a>
                     <a href="http://www.linkedin.com/company/15759?trk=tyah" class="mobclix" title="LinkedIn"><img src="img/in.png" width="26" height="26" alt="LinkedIn"></a>
               </section>

                </section>
                    </section>
                
				<script type="text/javascript">  /* <![CDATA[ */  document.write (    '<img src="http://ci26.actonsoftware.com/acton/bn/3028/visitor.gif?ts='+    new Date().getTime()+    '&ref='+escape(document.referrer) + '">'  );  /* ]]> */</script>
            </section>
	  	</section>
	</div>
</div>

<footer class="bottom">
	<section class="b-copyright">
		<p>&copy; 2012 Velti plc and its subsidiaries.</p>
	</section>
	<aside class="nasdaq"><a target="blank" href="http://investors.velti.com"><img src="img/nasdaq.png" alt="Listed on Nasdaq" title="Listed on Nasdaq" width="88" height="29" /></a></aside>
	<nav class="b-btmnav">
		<ul>
			<li><a href="about.html">About Us</a></li>
			<li><a href="press.html">News &amp; Events</a></li>
			<li><a href="careers.html">Careers</a></li>
			<li><a href="contact-us.html">Contact Us</a></li>
			<li><a href="terms.html">Terms &amp; Conditions</a></li>
			<li><a href="privacy.html">Privacy Policy</a></li>
			<!--li><a href="investors.html">investors</a></li-->
		</ul>
	</nav>
</footer>
<script type="text/javascript">
	function noError(){return true;}
	window.onerror = noError;
</script>
</body>
</html>
