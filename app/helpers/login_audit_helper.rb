#
# Copyright (C) 2018 Martin Denizet <martin.denizet@supinfo.com>
#
module LoginAuditHelper

  def choices_for_purge
    my_array = []
    12.times do |i|
      my_array<<[i+1, i+1]
    end
    my_array
  end

  def success_image(success=true)
    image_tag(success ? 'true.png' : 'false.png')
  end
end