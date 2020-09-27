import React from 'react';
import PropTypes from 'prop-types';

class File extends React.Component {
  componentDidMount() {
  }

  render() {
    const { input } = this.props;
    const onAttachmentChange = (e) => {
      e.preventDefault();
      const files = [...e.target.files];
      input.onChange(files);
    };
    return (
      <div>
        <input
          type="file"
          onChange={onAttachmentChange}
        />
      </div>
    );
  }
}

// propTypesの定義
File.propTypes = {
  input: PropTypes.shape(),
};

// defaultPropsの定義
File.defaultProps = {
  input: undefined,
};

export default File;
