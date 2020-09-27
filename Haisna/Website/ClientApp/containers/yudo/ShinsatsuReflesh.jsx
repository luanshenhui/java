/**
 * @file 誘導診察状態表示
 */
import React from 'react';
import PropTypes from 'prop-types';
import { connect } from 'react-redux';
import { bindActionCreators } from 'redux';

// 共通コンポーネント
import MessageBanner from '../../components/MessageBanner';

// 誘導モジュール
import * as yudoModule from '../../modules/yudo/yudoModule';

// 呼び出し音声ファイル
import sound from '../../sounds/REMINDER.mp3';

// 誘導診察状態表示用コンポーネント
import Banner from '../../components/yudo/ShinsatsuReflesh/Banner';
import Rooms from '../../components/yudo/ShinsatsuReflesh/Rooms';

const mapStateToProps = (state) => ({
  pageState: state.app.yudo.yudo.consultationMonitorStatus,
});

const mapDispatachToProps = (dispatch) => ({
  yudoActions: bindActionCreators(yudoModule, dispatch),
});

class ShinsatsuReflesh extends React.Component {
  componentDidMount() {
    // ページを初期化
    this.props.yudoActions.initializeYudoConsultationMonitorStatus();
    // タイマーをセット
    const intervalId = setInterval(() => this.props.yudoActions.getYudoConsultationMonitorStatusRequest(), 10000);
    // タイマーをスタート
    this.props.yudoActions.startGetYudoConsultationMonitorStatus({ intervalId, sound: new Audio(sound) });
  }

  componentWillUnmount() {
    // タイマーをストップ
    this.props.yudoActions.stopGetYudoConsultationMonitorStatus();
    // ページを初期化
    this.props.yudoActions.initializeYudoConsultationMonitorStatus();
  }

  // レンダリング
  render() {
    return (
      <div>
        <Banner />
        <MessageBanner messages={this.props.pageState.messages} />
        <Rooms {...this.props.pageState.rooms} />
      </div>
    );
  }
}

// propTypesを定義
ShinsatsuReflesh.propTypes = {
  pageState: PropTypes.shape().isRequired,
  yudoActions: PropTypes.shape().isRequired,
};

export default connect(mapStateToProps, mapDispatachToProps)(ShinsatsuReflesh);
