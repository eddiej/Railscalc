class CalculationsController < ApplicationController
  
  MAPPINGS = {"difference"=>'-', 'sum'=>'+', 'multiplication'=>'*', 'division'=>'/'}
  
  def new
    @calculation = Calculation.new
  end

  def create
    operator = MAPPINGS[params['commit']] # get the string sent with the form submit and lookup the operator from the MAPPINGS hash.
    a,b = params[:calculation][:a].to_i, params[:calculation][:b].to_i # the operands.
    if ['+','*'].include? operator and b < a then a,b = b,a end # order of operands doesnt matter for sum or product. Sort before saving record to avoid needless calculations being saved.   
    c = Calculation.find_or_initialize_by(a: a, b: b, operator: operator) # Find or initialise the Calcualtion object.
    if c.new_record?
      c.result = eval("#{params[:calculation][:a].to_f} #{operator} #{params[:calculation][:b].to_f}") # Perform the calculation. 
      c.save!
    else   
      c.update_attributes({:count => c.count+1}) # Increment the number of calculations performed for these attributes
    end
    sleep(0.3) ## Inserted this so that the buttons can be seen in their disabled state, otherwise the ajax call is too fast for it to be seen.
    respond_to do |format|   
      format.text {render :text => "Operation: #{params[:calculation][:a]} #{operator} #{params[:calculation][:b]}\nResult: #{prettify(c.result)}\nID: #{c.id}\nCount: #{c.count-1} ", :status => 200}
    end
  end
  
  private
  
  def prettify(result) # only display decimal point when required.
    result == result.to_i ? result.to_i : result
  end
  
  
end
