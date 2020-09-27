import React from 'react';
import PropTypes from 'prop-types';

const MessageBanner = (props) => {
  const { messages } = props;
  return (
    <div>
      {
        messages.length > 0 && (
          <div>
            {messages.map((rec, index) => (
              <p key={index.toString()}>{rec}</p>
            ))}
          </div>
        )
      }
    </div>
  );
};

MessageBanner.propTypes = {
  messages: PropTypes.arrayOf(PropTypes.string).isRequired,
};

export default MessageBanner;
