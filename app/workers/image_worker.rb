class ImageWorker
    include Sidekiq::Worker
    sidekiq_options :backtrace => true

    def perform(variation_id, crop_x, crop_y, crop_w, crop_h, resize, autocreate, image_w, image_h)
        image_variation = ImageVariation.find(variation_id)
        image_variation.assign_attributes ({
            crop_x: crop_x,
            crop_y: crop_y,
            crop_w: crop_w,
            crop_h: crop_h,
            resize: resize,
            autocreate: autocreate,
            image_w: image_w,
            image_h: image_h
        })
        image_variation.upload_image
    end
end