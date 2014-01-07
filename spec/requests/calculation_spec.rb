require 'spec_helper'

describe 'Calculator page' do  
  before(:each) do
    visit root_path
  end

  it "shows the required components" do
    ['a', 'b'].each do |f| should have_field f end
    ['sum', 'difference', 'multiplication', 'division'].each do |action| should have_button action, :disabled => true end
    should have_field 'answer', :type => 'textarea', :disabled => true
  end
  
  it 'only allows two positive integers less than 100',:js => true do
    nonvalid = [
      ['a',''],
      [1,''],
      [1,'b'],
      [1,-1],
      [1,101],
      [0,0],
      [1,1.5]
    ]
    nonvalid.each do |a|
      fill_in :a, :with => a[0]
      fill_in :b, :with => a[1]
      ['sum', 'difference', 'multiplication', 'division'].each do |action| should have_button action, :disabled => true end
      sleep(0.5) # pause to allow effect to be seen.
    end    
    valid = [
      [1,1],
      [100,100]
    ]
    valid.each do |a|
      fill_in :a, :with => a[0]
      fill_in :b, :with => a[1]
      ['sum', 'difference', 'multiplication', 'division'].each do |action| should have_button action, :disabled => false end
      sleep(0.5) # pause to allow effect to be seen.
    end
  end
  
  
  it 'disables buttons when form is submitted', :js => true do
    fill_in :a, :with => '1' 
    fill_in :b, :with => '1'
    ['sum', 'difference', 'multiplication', 'division'].each do |action| should have_button action, :disabled => false end
    click_button 'sum'
    ['sum', 'difference', 'multiplication', 'division'].each do |action| should have_button action, :disabled => true end
  end
  
  
  it 'shows correct response',:js => true do
    combos = [
      [1,2,'sum','1 + 2',3,0], 
      [1,2,'sum','1 + 2',3,1],
      [2,1,'sum','2 + 1',3,2], # same as previous
      [1,2,'multiplication','1 * 2',2,0], 
      [2,1,'multiplication','2 * 1',2,1], # same as previous
      [2,1,'division','2 / 1',2,0],
      [1,2,'division','1 / 2',0.5,0], # not same as previous
      [1,2,'difference','1 - 2',-1,0], 
      [2,1,'difference','2 - 1',1,0] # not same as previous
    ]
    combos.each do |c|
      fill_in :a, :with => c[0]
      fill_in :b, :with => c[1]
      click_button c[2]
      sleep(0.5) # wait for the sleep method inserted into the controller to finish.
      find(:xpath, "//textarea").value.should =~ /Operation: #{Regexp.escape(c[3])}\nResult: #{c[4]}\nID: .*\nCount: #{c[5]}*/
    end
        
  end
  
end