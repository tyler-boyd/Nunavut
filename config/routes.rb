Nunavut::Application.routes.draw do

# STUPIDITY alert - this file is in the config directory, but it has nothing to do with the config of the rails framework
# Instead, it's an integral part of the app and it should be in the app directory.  Mental.

  root 'application#index'              # root points at the root of the website.  To find this, go to the rails controllers 
                                        # (somewhere in app/controllers), and look for the "index" method, (shown by a def declaration)
									    # In the index method there could be some code, but probably won't be.  Instead, the code that is 
										# executed is the default code in ActionController.  All user defined controllers inherit from 
										# ActionController, this, and so this makes sense 
										#
  
  ## Use either get or post depending the call method that the browser uses.  A standard link is generally a get, so "gets" are more common in this list 
  
  # This is an example of a standard link.  The link called is partial/contact.html and so I execute whatever code is in the controller application, 
  # using the method (or def) "contact" (in this example)
  # get '/partial/contact.html' => 'application#contact'
  #                                      ^         ^
  #                                  controller   method
  #
  
  # This is a special case of a wildcard match 
  # the match is first made against the "partial/(*partial_name).  This means that ANYTHING matching "partial/*" matches this.   Putting something
  # in a bracket makes rails create a variable with that content with that name
  #
  # for example 
  #     if /partial/banana.html is sent to be deciphered here, then the partial bit is matched and the wildcard is matched and (*partial_name)
  #     is turned into a variable called partial_name and is sent to the controller.  The controller can use it as #{params[:partial_name]} 
  #     where the #{ } shows that it is a snippet of ruby code
  
  get '/partial/(*partial_name)' => 'application#partial'
  get '/assets/(*asset_name)' => 'application#asset'
  
  # REMEMBER - THE REQUESTED PATHNAME THAT COMES HERE IS THE PATHNAME ****AFTER**** ANGULAR HAS HAD A HACK AT IT, IF ANGULAR IS IN USE.
  # ANGULAR routes are set in the application.js file - stupidly buried in the routeProvider section
  
  # REMEMBER = it appears that one needs to RESTART the rails server when this file is changed.
  
end