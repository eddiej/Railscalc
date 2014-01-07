class CalculationsController < ApplicationController
  
  MAPPINGS = {"difference"=>'-', 'sum'=>'+', 'multiplication'=>'*', 'division'=>'/'}
  
  def new
    @calculation = Calculation.new
  end

  def create
    operator = MAPPINGS[params['commit']]
    a,b = params[:calculation][:a].to_i, params[:calculation][:b].to_i
    if ['+','*'].include? operator and b < a then a,b = b,a end # order of operands doesnt matter for sum or product. Sort before saving record to avoid needless calculations being saved.   
    c = Calculation.find_or_initialize_by(a: a, b: b, operator: operator)
    if c.new_record?
      c.result = eval("#{params[:calculation][:a].to_f} #{operator} #{params[:calculation][:b].to_f}")
      c.save!
    else   
      c.update_attributes({:count => c.count+1}) # c.inc(:count,1) doesn't appear to be working with current alpha release of mongoid for Rails 4 (mongoid 4.0.0.alpha1) so using slightly longer method below
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
