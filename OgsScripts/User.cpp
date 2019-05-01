#include <Origin.h>

//#pragma labtalk(0) // to disable OC functions for LT calling.

#define    DBG_OUT(_text, _value)     out_int(_text, _value);

void Layer_ListGraphObject()
{
    GraphLayer gl = Project.ActiveLayer();
    if(!gl)
        return;
    
	// List all graph objects in layer by their index and name
	GraphObject grobj;
	out_str( "List of all graph objects currently in layer:" );
    foreach( grobj in gl.GraphObjects )
		printf( "   GraphObject index, name: %d, %s, \n", grobj.GetIndex(), grobj.GetName(), grobj.GetObjectType() );
}

void Layer_ListDataPlots()
{
    GraphLayer gl = Project.ActiveLayer();
    if(!gl)
        return;
    
	// Loop over all the dataplots in the collection:
	out_str( "List of all dataplots currently in layer:" );
    foreach (DataPlot dp in gl.DataPlots)
    {
        printf( "   DataPlots index, name, plotType: %d, %s, %d\n", dp.GetIndex(), dp.GetName(), dp.GetPlotType());
    }
}

void Layer_SetNormalTextStyle()
{
    GraphLayer gl = Project.ActiveLayer();
    if(!gl)
        return;

	GraphObject grobj;
    foreach( grobj in gl.GraphObjects ){
    	string type = grobj.GetObjectType();
    	string name = grobj.GetName();
    	if (!type.Compare("Text")&&name.Compare("YR")&&name.Compare("XT")&&name.Compare("XB")&&name.Compare("YL")){
			char str[100],bd_text[100];
			strcat(str,name);
			strcat(str,".fsize = 25;");
			strcat(str,name);
			strcat(str,".font = font(Arial);");
			LT_execute(str);
			sprintf(bd_text,"\\b(%s)",grobj.Text);
			grobj.Text=bd_text;
    	}
    }
}

void Layer_SetDefaultDataPlotsStyle()
{
    GraphLayer gl = Project.ActiveLayer();
    if(!gl)
        return;
    
    foreach (DataPlot dp in gl.DataPlots)
    {
    	Tree trFormat;
    	//trFormat = dp.GetFormat(FPB_ALL	, FOB_ALL, true, true);
		//out_tree(trFormat); // output format tree
		int type = dp.GetPlotType();
        Tree tr;
        switch(type){
        case IDM_PLOT_LINE:
        	out_str("Line");
			tr.Root.Line.Width.nVal = 4;
            if(0 == dp.UpdateThemeIDs(tr.Root))
				dp.ApplyFormat(tr, true, true);
        	break;
        case IDM_PLOT_SCATTER:
        	out_str("Scatter");
        	vector vX, vY;
			dp.GetDataPoints(0, -1, vX, vY);
			if (vX.GetSize()<=10)
				tr.Root.Symbol.Size.nVal = 9;
			else if (vX.GetSize()<=50)
				tr.Root.Symbol.Size.nVal = 6;
			else if (vX.GetSize()<=100)
				tr.Root.Symbol.Size.nVal = 4;
			else
				tr.Root.Symbol.Size.nVal = 2;
			if(0 == dp.UpdateThemeIDs(tr.Root))
				dp.ApplyFormat(tr, true, true);
        	break;
        case IDM_PLOT_LINESYMB:
        	out_str("Line+symbol");
        	tr.Root.Line.Width.nVal = 4;
        	tr.Root.Symbol.Size.nVal = 15;
        	if(0 == dp.UpdateThemeIDs(tr.Root))
				dp.ApplyFormat(tr, true, true);
        	break;
        case IDM_PLOT_ERRBAR:
        	out_str("Error Bar");
        	tr.Root.Line.Width.nVal = 3;
        	if(0 == dp.UpdateThemeIDs(tr.Root))
				dp.ApplyFormat(tr, true, true);
        	break;
        	break;
        default:
        	out_str("Undefined");
        	break;
        }
    }
}