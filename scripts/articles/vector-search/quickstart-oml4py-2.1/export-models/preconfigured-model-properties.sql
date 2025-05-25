column model_path_name format a60
column details format a80
column model_type format a15


set pagesize 50


with base as (
select
json(
to_clob('[')
|| to_clob(q'#{
        "model_path_name":"sentence-transformers/all-mpnet-base-v2",
        "do_lower_case": True, 
        "post_processors": [{"name": "Pooling", "type": "mean"}, {"name": "Normalize"}], 
        "distance_metrics": ["COSINE", "DOT", "EUCLIDEAN"], 
        "languages": ["us"], 
        "max_seq_length": 384, 
        "checksum": "be647852cec0a7658375495b76962bf9ec9412e279901c86695290f8a48b9c36", 
        "quantize_model": True, 
        "model_type": "TEXT"
},#')
|| to_clob(q'#{
        "model_path_name":"sentence-transformers/all-MiniLM-L6-v2",
        "do_lower_case": True, 
        "post_processors": [{"name": "Pooling", "type": "mean"}, {"name": "Normalize"}], 
        "distance_metrics": ["COSINE", "DOT", "EUCLIDEAN"], 
        "languages": ["us"], 
        "max_seq_length": 256, 
        "checksum": "f931f6dc592102f9e7693fe763fe35ce539e51da11e8055d50cf0ee88f5f4ce0", 
        "model_type": "TEXT"
},#')
|| to_clob(q'#{  
        "model_path_name":"sentence-transformers/multi-qa-MiniLM-L6-cos-v1",
        "do_lower_case": True, 
        "post_processors": [{"name": "Pooling", "type": "mean"}, {"name": "Normalize"}], 
        "distance_metrics": ["COSINE", "DOT", "EUCLIDEAN"], 
        "languages": ["us", "d", "f", "esm"], 
        "max_seq_length": 512, 
        "checksum": "1d657f78c41356a0f6d2bc5d069f8a9ae5a036bc3eccadeafcc235008a3f669b", 
        "model_type": "TEXT"
},#')
|| to_clob(q'#{
        "model_path_name":"sentence-transformers/distiluse-base-multilingual-cased-v2",
        "do_lower_case": False, 
        "post_processors": 
            [
            {"name": "Pooling", "type": "mean"}, 
            {"name": "Dense", "in_features": 768, "out_features": 512, "bias": True, "activation_function": "Tanh"}
            ], 
        "distance_metrics": ["COSINE"], 
        "languages": 
            ["ar", "bg", "ca", "cs", "dk", "d", "us", "el", "et", "fa", "sf", "f", "frc", "gu", "iw", "hi", "hr", 
            "hu", "hy", "in", "i", "ja", "ko", "lt", "lv", "mk", "mr", "ms", "n", "nl", "pl", "pt", "ptb", "ro", 
            "ru", "sk", "sl", "sq", "lsr", "s", "th", "tr", "uk", "ur", "vn", "zhs", "zht"], 
        "max_seq_length": 128, 
        "checksum": "eeaf6f21f79c42a9b38d56c5dc440440efd4c1afac0b7c37fca0fba114af373d", 
        "quantize_model": True, 
        "model_type": "TEXT"
},#')
|| to_clob(q'#{
        "model_path_name": "sentence-transformers/all-MiniLM-L12-v2", 
        "do_lower_case": True, 
        "post_processors": [{"name": "Pooling", "type": "mean"}, {"name": "Normalize"}], 
        "distance_metrics": ["COSINE", "DOT", "EUCLIDEAN"], 
        "languages": ["us"], 
        "max_seq_length": 256, 
        "checksum": "6c4dea8e58882ee6827c5855b28db372fda45a12b2bb31d995b07582b1bee9e0", 
        "model_type": "TEXT"
},#')
|| to_clob(q'#{
        "model_path_name":"BAAI/bge-small-en-v1.5",
        "do_lower_case": True, 
        "post_processors": [{"name": "Pooling", "type": "mean"}, {"name": "Normalize"}], 
        "distance_metrics": ["COSINE"], 
        "languages": ["us"], 
        "max_seq_length": 512, 
        "checksum": "e5dd8407c6d42b88b356e6497ce5ffd5455d625a9afd564ea1cba8f7c3e27175", 
        "model_type": "TEXT"
},#')
|| to_clob(q'#{
        "model_path_name":"BAAI/bge-base-en-v1.5", 
        "do_lower_case": True, 
        "post_processors": [{"name": "Pooling", "type": "mean"}, {"name": "Normalize"}], 
        "distance_metrics": ["COSINE"], 
        "languages": ["us"], 
        "max_seq_length": 512, 
        "checksum": "393be8692afc7e5803cc83175daf08d3abd195977e9137d74d5ad7a590cb0b92", 
        "quantize_model": True, 
        "model_type": "TEXT"
},#')
|| to_clob(q'#{
        "model_path_name":"taylorAI/bge-micro-v2",
        "do_lower_case": True, 
        "post_processors": [{"name": "Pooling", "type": "mean"}, {"name": "Normalize"}], 
        "distance_metrics": ["COSINE"], 
        "languages": ["us"], 
        "max_seq_length": 512, 
        "use_float16": True, 
        "checksum": "d82dcd72c469903355db29278b9ad17d26a4df28afc8a39ecc0607eef198c677", 
        "model_type": "TEXT"
},#')
|| to_clob(q'#{
        "model_path_name":"intfloat/e5-small-v2",
        "do_lower_case": True, 
        "post_processors": [{"name": "Pooling", "type": "mean"}, {"name": "Normalize"}], 
        "distance_metrics": ["COSINE"], 
        "languages": ["us"], 
        "max_seq_length": 512, 
        "checksum": "6e959c0d6f7559f98d832ea9d75afc03569aa89c7b967830d25011f699604648", 
        "model_type": "TEXT"
},#')
|| to_clob(q'#{
        "model_path_name":"intfloat/e5-base-v2",
        "do_lower_case": True, 
        "post_processors": [{"name": "Pooling", "type": "mean"}, {"name": "Normalize"}], 
        "distance_metrics": ["COSINE"], 
        "languages": ["us"], 
        "max_seq_length": 512, 
        "checksum": "86d1ce3d71ee3e9da1c2177858d590c7bc360f385248144b89c8d1441c227fc6", 
        "quantize_model": True, 
        "model_type": "TEXT"
},#')
|| to_clob(q'#{
        "model_path_name":"thenlper/gte-base",
        "do_lower_case": True, 
        "post_processors": [{"name": "Pooling", "type": "mean"}, {"name": "Normalize"}], 
        "distance_metrics": ["COSINE"], 
        "languages": ["us"], 
        "max_seq_length": 512, 
        "use_float16": True, 
        "checksum": "7d786e661409a48ae396c0b04b1f6a0a40b3cd390779327a49da24702aac5778", 
        "model_type": "TEXT"
},#')
|| to_clob(q'#{
        "model_path_name":"thenlper/gte-small",
        "do_lower_case": True, 
        "post_processors": [{"name": "Pooling", "type": "mean"}, {"name": "Normalize"}], 
        "distance_metrics": ["COSINE"], 
        "languages": ["us"], 
        "max_seq_length": 512, 
        "use_float16": True, 
        "checksum": "c6a341533f7b45b5613520a289999628cb94337d2d48975e51a9c2cf984ecf71", 
        "model_type": "TEXT"
},#')
|| to_clob(q'#{
        "model_path_name":"TaylorAI/gte-tiny",
        "do_lower_case": True, 
        "post_processors": [{"name": "Pooling", "type": "mean"}, {"name": "Normalize"}], 
        "distance_metrics": ["COSINE"], 
        "languages": ["us"], 
        "max_seq_length": 512, 
        "use_float16": True, 
        "checksum": "8e476c879c79f982db0f65d429b7db7c8edd2f5097a5ba18a16c505f5744c28e", 
        "model_type": "TEXT"
},#')
|| to_clob(q'#{
        "model_path_name":"sentence-transformers/paraphrase-multilingual-mpnet-base-v2",
        "do_lower_case": True, 
        "post_processors": [{"name": "Pooling", "type": "mean"}, {"name": "Normalize"}], 
        "distance_metrics": ["COSINE"], 
        "languages": 
            ["us", "ar", "bg", "ca", "cs", "dk", "d", "el", "gb", "e", "et", "fa", "sf", "f", 
            "gu", "iw", "hi", "hr", "hu", "hy", "in", "i", "ja", "ko", "lt", "lv", "mk", "mr", 
            "ms", "nl", "pl", "pt", "ro", "ru", "sk", "sl", "sq", "s", "th", "tr", "uk", "ur", "vn"], 
        "max_seq_length": 512, 
        "checksum": "c51c3acc79acf777c62cb42d3dd5bc02fc57afde87b5a1aefb21b0688534518a", 
        "quantize_model": True, 
        "model_type": "TEXT"
},#')
|| to_clob(q'#{
        "model_path_name":"intfloat/multilingual-e5-base",
        "do_lower_case": True, 
        "post_processors": [{"name": "Pooling", "type": "mean"}, {"name": "Normalize"}], 
        "distance_metrics": ["COSINE"], 
        "languages": 
            ["us", "am", "ar", "as", "az", "be", "bg", "ca", "cs", "dk", "d", "el", "gb", 
            "e", "et", "eu", "fa", "sf", "f", "ga", "gu", "iw", "hi", "hr", "hu", "hy", 
            "in", "is", "i", "ja", "km", "kn", "ko", "lo", "lt", "lv", "mk", "ml", "mr", 
            "ms", "ne", "nl", "n", "or", "pl", "pt", "ro", "ru", "si", "sk", "sl", "sq", 
            "s", "sw", "ta", "te", "th", "tr", "uk", "ur", "vn"], 
        "max_seq_length": 512, 
        "checksum": "c2bf85d8f7d9dff379e6dfaa7a864d296a918b122ebf7409a4abee61b99528b5", 
        "quantize_model": True, "model_type": "TEXT"
},#')
|| to_clob(q'#{
        "model_path_name":"intfloat/multilingual-e5-small",
        "do_lower_case": True, 
        "post_processors": [{"name": "Pooling", "type": "mean"}, {"name": "Normalize"}], 
        "distance_metrics": ["COSINE"], 
        "languages": 
            ["us", "am", "ar", "as", "az", "be", "bg", "ca", "cs", "dk", "d", "el", "gb", "e", 
            "et", "eu", "fa", "sf", "f", "ga", "gu", "iw", "hi", "hr", "hu", "hy", "in", "is", 
            "i", "ja", "km", "kn", "ko", "lo", "lt", "lv", "mk", "ml", "mr", "ms", "ne", "nl", 
            "n", "or", "pl", "pt", "ro", "ru", "si", "sk", "sl", "sq", "s", "sw", "ta", "te", 
            "th", "tr", "uk", "ur", "vn"], 
            "max_seq_length": 512, 
            "checksum": "bb40d156841decd031cc816d03791e7a0dfc4e4eedc93ca5013b46dad3f892db", 
            "quantize_model": True, 
            "model_type": "TEXT"
},#')
|| to_clob(q'#{
        "model_path_name":"sentence-transformers/stsb-xlm-r-multilingual",
        "do_lower_case": True, 
        "post_processors": [{"name": "Pooling", "type": "mean"}, {"name": "Normalize"}], 
        "distance_metrics": ["COSINE"], 
        "languages": ["us"], 
        "max_seq_length": 512, 
        "checksum": "d78f6e5ae352ddccd06fda98daebec1bbb7c2755026222e8612157a4e448f906", 
        "quantize_model": True, 
        "model_type": "TEXT"
},#')
|| to_clob(q'#{
        "model_path_name":"Snowflake/snowflake-arctic-embed-xs",
        "do_lower_case": True, 
        "post_processors": [{"name": "Pooling", "type": "mean"}, {"name": "Normalize"}], 
        "distance_metrics": ["COSINE"], 
        "languages": ["us"], 
        "max_seq_length": 512, 
        "checksum": "dc1cf555778eaf2bc8c8cbd52929e58e930a50539d96bd2aef05c4667c9afef1", 
        "model_type": "TEXT"
},#')
|| to_clob(q'#{
        "model_path_name":"Snowflake/snowflake-arctic-embed-s",
        "do_lower_case": True, 
        "post_processors": [{"name": "Pooling", "type": "mean"}, {"name": "Normalize"}], 
        "distance_metrics": ["COSINE"], 
        "languages": ["us"], 
        "max_seq_length": 512, 
        "checksum": "a4e1c3e0397361c6add42a542052e40e32f679a44d33829659d31592e078a3f1", 
        "model_type": "TEXT"
},#')
|| to_clob(q'#{
        "model_path_name":"Snowflake/snowflake-arctic-embed-m",        
        "do_lower_case": True, 
        "post_processors": [{"name": "Pooling", "type": "mean"}, {"name": "Normalize"}], 
        "distance_metrics": ["COSINE"], 
        "languages": ["us"], 
        "max_seq_length": 512, 
        "checksum": "cc17acb7d96a63f74b7e8ecca3d2a2c21fd98df606bdd67346ba88eb81e74eef", 
        "quantize_model": True, 
        "model_type": "TEXT"
},#')
|| to_clob(q'#{
        "model_path_name":"mixedbread-ai/mxbai-embed-large-v1",        
        "do_lower_case": True, 
        "post_processors": [{"name": "Pooling", "type": "mean"}, {"name": "Normalize"}], 
        "distance_metrics": ["COSINE"], 
        "languages": ["us"], 
        "max_seq_length": 512, 
        "checksum": "91df8b84fdb1197c0e8db0782160339794930accc8f154ad80a498a7b562b435", 
        "quantize_model": True, 
        "model_type": "TEXT"
},#')
|| to_clob(q'#{
        "model_path_name":"openai/clip-vit-large-patch14",        
        "max_seq_length": 77, 
        "do_lower_case": True, 
        "post_processors": [{"name": "Normalize"}], 
        "distance_metrics": ["COSINE"], 
        "languages": ["us"], 
        "checksum": "010cf7792646b40a3d8ed9bb39d2f223944170d32fbeb36207f9fbf4eeed935c", 
        "quantize_model": True, 
        "model_type": "MULTIMODAL_CLIP", 
        "pre_processors_img": [
            {"name": "DecodeImage", "do_convert_rgb": True}, 
            {"name": "Resize", "enable": True, "size": {"shortest_edge": 224}, "resample": "bicubic"}, 
            {"name": "CenterCrop", "enable": True, "crop_size": {"height": 224, "width": 224}}, 
            {"name": "Rescale", "enable": True, "rescale_factor": 0.00392156862}, 
            {"name": "Normalize", "enable": True, "image_mean": "OPENAI_CLIP_MEAN", "image_std": "OPENAI_CLIP_STD"}, 
            {"name": "OrderChannels", "order": "CHW"}], 
        "post_processors_img": []
},#')
|| to_clob(q'#{
        "model_path_name":"google/vit-base-patch16-224",        
        "checksum": "beaffddb81f18163b991541becd355e54db6d27b57b7df4d440997a74f5786ff", 
        "model_type": "IMAGE_VIT", 
        "pre_processors_img": [
            {"name": "DecodeImage", "do_convert_rgb": True}, 
            {"name": "Resize", "enable": True, "size": {"height": 224, "width": 224}, "resample": "bilinear"}, 
            {"name": "Rescale", "enable": True, "rescale_factor": 0.00392156862}, 
            {"name": "Normalize", "enable": True, "image_mean": "IMAGENET_STANDARD_MEAN", "image_std": "IMAGENET_STANDARD_STD"}, 
            {"name": "OrderChannels", "order": "CHW"}], 
        "post_processors_img": []
},#')
|| to_clob(q'#{
        "model_path_name":"microsoft/resnet-18",        
        "checksum": "fb749de60cdcc676f5049aa5c00fab19ea1d312b9ad8c2961737aa1a13d56520", 
        "model_type": "IMAGE_CONVNEXT", 
        "pre_processors_img": [
            {"name": "DecodeImage", "do_convert_rgb": True}, 
            {"name": "Resize", "enable": True, "size": {"height": 384, "width": 384}, "resample": "bilinear"}, 
            {"name": "Rescale", "enable": True, "rescale_factor": 0.00392156862}, 
            {"name": "Normalize", "enable": True, "image_mean": "IMAGENET_STANDARD_MEAN", "image_std": "IMAGENET_STANDARD_STD"}, 
            {"name": "OrderChannels", "order": "CHW"}], 
        "post_processors_img": []
},#')
|| to_clob(q'#{
        "model_path_name":"microsoft/resnet-50",        
        "checksum": "fca7567354d0cb0b7258a44810150f7c1abf8e955cff9320b043c0554ba81f8e", 
        "model_type": "IMAGE_CONVNEXT", 
        "pre_processors_img": [
            {"name": "DecodeImage", "do_convert_rgb": True}, 
            {"name": "Resize", "enable": True, "size": {"height": 384, "width": 384}, "resample": "bilinear"}, 
            {"name": "Rescale", "enable": True, "rescale_factor": 0.00392156862}, 
            {"name": "Normalize", "enable": True, "image_mean": "IMAGENET_STANDARD_MEAN", "image_std": "IMAGENET_STANDARD_STD"}, 
            {"name": "OrderChannels", "order": "CHW"}], 
        "post_processors_img": []
},#')
|| to_clob(q'#{
        "model_path_name":"WinKawaks/vit-tiny-patch16-224",        
        "checksum": "2213c4e82776c1e77564df09e8e7d1eedb8978ddfa8f5f001204cbf378800205", 
        "model_type": "IMAGE_VIT", 
        "pre_processors_img": [
            {"name": "DecodeImage", "do_convert_rgb": True}, 
            {"name": "Resize", "enable": True, "size": {"height": 224, "width": 224}, "resample": "bilinear"}, 
            {"name": "Rescale", "enable": True, "rescale_factor": 0.00392156862}, 
            {"name": "Normalize", "enable": True, "image_mean": "IMAGENET_STANDARD_MEAN", "image_std": "IMAGENET_STANDARD_STD"}, 
            {"name": "OrderChannels", "order": "CHW"}], 
        "post_processors_img": []
},#')
|| to_clob(q'#{
        "model_path_name":"Falconsai/nsfw_image_detection",        
        "checksum": "98427273b394524ba714032174e919ab8e79789c7aef2b14245242a101af088d", 
        "model_type": "IMAGE_VIT", 
        "pre_processors_img": [
            {"name": "DecodeImage", "do_convert_rgb": True}, 
            {"name": "Resize", "enable": True, "size": {"height": 224, "width": 224}, "resample": "bilinear"}, 
            {"name": "Rescale", "enable": True, "rescale_factor": 0.00392156862}, 
            {"name": "Normalize", "enable": True, "image_mean": "IMAGENET_STANDARD_MEAN", "image_std": "IMAGENET_STANDARD_STD"}, 
            {"name": "OrderChannels", "order": "CHW"}], 
        "post_processors_img": []
},#')
|| to_clob(q'#{
        "model_path_name":"WinKawaks/vit-small-patch16-224",        
        "checksum": "d2e7b93b9a8826968fa3dba9891d11dc4f3449015bee6706536c1e73f959f709", 
        "model_type": "IMAGE_VIT", 
        "pre_processors_img": [
            {"name": "DecodeImage", "do_convert_rgb": True}, 
            {"name": "Resize", "enable": True, "size": {"height": 224, "width": 224}, "resample": "bilinear"}, 
            {"name": "Rescale", "enable": True, "rescale_factor": 0.00392156862}, 
            {"name": "Normalize", "enable": True, "image_mean": "IMAGENET_STANDARD_MEAN", "image_std": "IMAGENET_STANDARD_STD"}, 
            {"name": "OrderChannels", "order": "CHW"}], 
        "post_processors_img": []
},#')
|| to_clob(q'#{
        "model_path_name":"nateraw/vit-age-classifier",        
        "checksum": "80c7610807d8dee9d38f0baea16924303550d59d2d155f49c4d2294849a394d2", 
        "model_type": "IMAGE_VIT", 
        "pre_processors_img": [
            {"name": "DecodeImage", "do_convert_rgb": True}, 
            {"name": "Resize", "enable": True, "size": {"height": 224, "width": 224}, "resample": "bilinear"}, 
            {"name": "Rescale", "enable": True, "rescale_factor": 0.00392156862}, 
            {"name": "Normalize", "enable": True, "image_mean": "IMAGENET_STANDARD_MEAN", "image_std": "IMAGENET_STANDARD_STD"}, 
            {"name": "OrderChannels", "order": "CHW"}], 
        "post_processors_img": []
},#')
|| to_clob(q'#{
        "model_path_name":"rizvandwiki/gender-classification",        
        "checksum": "834c9fd8abeda91f762e779e2ab80a5f153e73ff84384d827d191055a1ede797", 
        "model_type": "IMAGE_VIT", 
        "pre_processors_img": [
            {"name": "DecodeImage", "do_convert_rgb": True}, 
            {"name": "Resize", "enable": True, "size": {"height": 224, "width": 224}, "resample": "bilinear"}, 
            {"name": "Rescale", "enable": True, "rescale_factor": 0.00392156862}, 
            {"name": "Normalize", "enable": True, "image_mean": "IMAGENET_STANDARD_MEAN", "image_std": "IMAGENET_STANDARD_STD"}, 
            {"name": "OrderChannels", "order": "CHW"}], 
        "post_processors_img": []
},#')
|| to_clob(q'#{
        "model_path_name":"AdamCodd/vit-base-nsfw-detector",        
        "checksum": "c8441ca4fc7341c43ed6911f6dcbe5ca38f93f2225abc19a3efb71ea907fe7d2", 
        "model_type": "IMAGE_VIT", 
        "pre_processors_img": [
            {"name": "DecodeImage", "do_convert_rgb": True}, 
            {"name": "Resize", "enable": True, "size": {"height": 224, "width": 224}, "resample": "bilinear"}, 
            {"name": "Rescale", "enable": True, "rescale_factor": 0.00392156862}, 
            {"name": "Normalize", "enable": True, "image_mean": "IMAGENET_STANDARD_MEAN", "image_std": "IMAGENET_STANDARD_STD"}, 
            {"name": "OrderChannels", "order": "CHW"}], 
        "post_processors_img": []
},#')
|| to_clob(q'#{
        "model_path_name":"trpakov/vit-face-expression",        
        "checksum": "8960f3a5dad4d109a9478c175a5a08e45286c0d2ec5604f55c61d2814a2f179a", 
        "model_type": "IMAGE_VIT", 
        "pre_processors_img": [
            {"name": "DecodeImage", "do_convert_rgb": True}, 
            {"name": "Resize", "enable": True, "size": {"height": 224, "width": 224}, "resample": "bilinear"}, 
            {"name": "Rescale", "enable": True, "rescale_factor": 0.00392156862}, 
            {"name": "Normalize", "enable": True, "image_mean": "IMAGENET_STANDARD_MEAN", "image_std": "IMAGENET_STANDARD_STD"}, 
            {"name": "OrderChannels", "order": "CHW"}], 
        "post_processors_img": []
},#')
|| to_clob(q'#{
        "model_path_name":"BAAI/bge-reranker-base",        
        "do_lower_case": True, 
        "post_processors": [], 
        "distance_metrics": ["COSINE"], 
        "languages": ["us", "zhs"], 
        "max_seq_length": 512, 
        "checksum": "c9b7db292f323ef4158921dd1881963fbe2b7ae19db1de406b5391e16ed53c56", 
        "quantize_model": True, 
        "function": "REGRESSION", 
        "model_type": "TEXT"
}#')
|| to_clob(']')
)
as jdoc
), parse_base as (
select j.* 
from base b,
json_table(b.jdoc, '$[*]'
    columns(
        model_path_name path '$.model_path_name.string()'
        , do_lower_case boolean path '$.do_lower_case'
        , distance_metrics json path '$.distance_metrics'
        , max_seq_length number path '$.max_seq_length.number()'
        , quantize_model boolean path '$.quantize_model'
        , mining_function path '$.function.string()'
        , model_type path '$.model_type.string()'
        , post_processors json path '$.post_processors'
        , pre_processors_img json path '$.pre_processors_img'
        , post_processors_img json path '$.post_processors_img'
        , languages json path '$.languages'
    )
) j
)
select 
    b.model_path_name
    , model_type || ' ' 
    || case when quantize_model then '[quantize=True]' end
    || case when mining_function is not null then '[mining_function='||mining_function ||']' end
    || case when distance_metrics is not null then 
        '[metrics: ' ||
        translate(
            json_serialize(distance_metrics returning varchar2)
            ,'x["]','x') || ']'
        end as details
from parse_base b
order by b.mining_function nulls first, b.model_type, b.model_path_name
/
