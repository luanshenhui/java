import React from 'react';
import PropTypes from 'prop-types';

import TitleBar from '../../components/TitleBar';
import MessageBanner from '../../components/MessageBanner';

const EditBase = (props) => {
  const { title, messages, children } = props;
  return (
    <div>
      <TitleBar>
        <span>{title}</span>
      </TitleBar>
      <MessageBanner messages={messages} />
      {children}
    </div>
  );
};

EditBase.propTypes = {
  title: PropTypes.string.isRequired,
  messages: PropTypes.arrayOf(PropTypes.string).isRequired,
  children: PropTypes.element.isRequired,
};

export default EditBase;
