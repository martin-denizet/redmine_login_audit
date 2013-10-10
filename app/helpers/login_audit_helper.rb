module LoginAuditHelper

  def choices_for_purge
    my_array = []
    12.times do |i|
      my_array<<[i+1, i+1]
    end
    my_array
  end
end
