module StorefrontAPI
  class Image < Base
    delegate :transformed_src,
             to: :data

    def src(width=320)
      self.data.transformed_src.gsub("1234", width.to_s)
    end
  end
end
