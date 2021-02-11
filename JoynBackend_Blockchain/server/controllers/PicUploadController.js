const upload = require("../middleware/PicUploadMiddleware");

const multipleUpload = async (req, res, next) => {
  try {
    await upload(req, res);
    if (req.files.length <= 0) {
      return res.status(400).json({
        msg:"You must select at least 1 file.",
        result:false
      });
    }
    return next();
  } catch (error) {
    console.log(error);

    if (error.code === "LIMIT_UNEXPECTED_FILE") {
      return res.status(400).json({
        msg:"Too many files to upload. Max Limit is 10",
        result:false
      });
    }
    return res.status(500).json({
        msg:"Error when trying upload many files",
        result:false,
        error:error
    });
  }
};

module.exports = {
  multipleUpload: multipleUpload
};