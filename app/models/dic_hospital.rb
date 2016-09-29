class DicHospital < ActiveRecord::Base
  def level_zh
    en_to_zh = {
      "level1" => "一级甲等",
      "level2" => "一级乙等",
      "level3" => "一级丙等",
      "level4" => "二级甲等",
      "level5" => "二级乙等",
      "level6" => "二级丙等",
      "level7" => "三级甲等",
      "level8" => "三级乙等",
      "level9" => "三级丙等",
      "level_other" => "其它"
    }
    en_to_zh[self.level]
  end

end
