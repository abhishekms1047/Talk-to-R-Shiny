var initVoice = function() {
  if (annyang) {
    
    var zoom=4;
    //Default input values
    Shiny.onInputChange('zip',75252);
    Shiny.onInputChange('color','education');
    Shiny.onInputChange('size', 'income');
    Shiny.onInputChange('top',0);
    Shiny.onInputChange('feature',"income");
    Shiny.onInputChange('zoom',4);
    Shiny.onInputChange('plotx','income');
    Shiny.onInputChange('ploty','education');
    Shiny.onInputChange('remove',3);
    
    
    //Inputs for voice command 
    var commands = {
      'go (to) (zip) (code) :zip': function(zip) {
        Shiny.onInputChange('zip', zip);
        
      },
      'color (by) :color': function(color) {
        Shiny.onInputChange('color', color);
      },
      'size (by) :size': function(size) {
        Shiny.onInputChange('size', size);
      },
      '(zoom) in': function() {
        zoom=zoom+1;
        Shiny.onInputChange('zoom', zoom);
      },
      '(zoom) out': function() {
        zoom=zoom-1;
        Shiny.onInputChange('zoom', zoom);
      },
      'top :top (places) (by) population': function(top) {
        
        if(top=='one')
        {
          top=1;
        }
        else if (top=='two')
        {
          top=2;
        }
        else if (top=='three')
        {
          top=3;
        }
        
        else if (top=='four')
        {
          top=4;
        }
        
        else if (top=='five')
        {
          top=5;
        }
        
        else if (top=='six')
        {
          top=6;
        }
        
        else if (top=='seven')
        {
          top=7;
        }
        
        else if (top=='eight')
        {
          top=8;
        }
        
        
        else if (top=='nine')
        {
          top=9;
        }
        else
        {
          
          //Do Nothing
          
        }
      
        Shiny.onInputChange('feature','education');
        Shiny.onInputChange('top',parseInt(top));
        },
      'top :top (places) (by) income': function(top) {
         if(top=='one')
        {
          top=1;
        }
        else if (top=='two')
        {
          top=2;
        }
        else if (top=='three')
        {
          top=3;
        }
        
        else if (top=='four')
        {
          top=4;
        }
        
        else if (top=='five')
        {
          top=5;
        }
        
        else if (top=='six')
        {
          top=6;
        }
        
        else if (top=='seven')
        {
          top=7;
        }
        
        else if (top=='eight')
        {
          top=8;
        }
        
        
        else if (top=='nine')
        {
          top=9;
        }
        else
        {
         //Do Nothing
        }
        
        
        Shiny.onInputChange('feature','income');
        Shiny.onInputChange('top',parseInt(top));
        },
      'top :top (places) (by) education': function(top) {
        
         if(top=='one')
        {
          top=1;
        }
        else if (top=='two')
        {
          top=2;
        }
        else if (top=='three')
        {
          top=3;
        }
        
        else if (top=='four')
        {
          top=4;
        }
        
        else if (top=='five')
        {
          top=5;
        }
        
        else if (top=='six')
        {
          top=6;
        }
        
        else if (top=='seven')
        {
          top=7;
        }
        
        else if (top=='eight')
        {
          top=8;
        }
        
        
        else if (top=='nine')
        {
          top=9;
        }
        else
        {
          
          //Do Nothing
        }
        Shiny.onInputChange('feature','education');
        Shiny.onInputChange('top',parseInt(top));
        },
      'graph :x by :y': function(x,y){
        Shiny.onInputChange('plotx',x);
        Shiny.onInputChange('ploty',y);
        },
      'remove': function(){
       Shiny.onInputChange('remove',3);
        }
    };
    
    annyang.addCommands(commands);
    annyang.debug();
    annyang.start();
  }
};

$(function() {
  setTimeout(initVoice, 10);
});
