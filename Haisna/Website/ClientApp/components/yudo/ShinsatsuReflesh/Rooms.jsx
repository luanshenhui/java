/**
 * @file 全診察室のコンポーネント
 */
import React from 'react';
import PropTypes from 'prop-types';

// 診察室コンポーネント
import Room from './Room';

// cssのインポート
import styles from './ShinsatsuReflesh.css';

// コンポーネントの定義
const Rooms = ({ room1, room2 }) => (
  <div className={styles.boxContainer}>
    <Room {...room1} className={styles.roomA} />
    <Room {...room2} className={styles.roomB} />
  </div>
);

// propTypesを定義する
Rooms.propTypes = {
  room1: PropTypes.shape().isRequired,
  room2: PropTypes.shape().isRequired,
};

export default Rooms;
