/**
 * @file 診察室コンポーネント
 */
import React from 'react';
import PropTypes from 'prop-types';

// cssのインポート
import styles from './ShinsatsuReflesh.css';

// コンポーネントの定義
const Room = ({ dayid, blink, className }) => {
  return (
    <div className={styles.box}>
      <div className={[styles.nameplate, className].join(' ')} />
      <div className={styles.dayid}>
        {blink ? <span className={styles.blinking}>{dayid}</span> : <span>{dayid}</span>}
      </div>
    </div>
  );
};

// propTypesを定義
Room.propTypes = {
  room_id: PropTypes.string.isRequired,
  dayid: PropTypes.number,
  blink: PropTypes.bool,
};

// defaultPropsを定義
Room.defaultProps = {
  dayid: null,
  blink: false,
};

export default Room;
