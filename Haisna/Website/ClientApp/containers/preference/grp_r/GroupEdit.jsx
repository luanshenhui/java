import React from 'react';
import PropTypes from 'prop-types';
import { Field, reduxForm } from 'redux-form';
import { connect } from 'react-redux';

import GroupEditItemTable from './GroupEditItemTable';
import ItemGuide from '../../../containers/common/ItemGuide';
import { initializeGroup, getGroupRequest, registerGroupRequest, deleteGroupRequest } from '../../../modules/preference/groupModule';
import { getAllItemClasses } from '../../../modules/preference/itemClassModule';
import { showItemGuide, hideItemGuide } from '../../../modules/preference/itemModule';

import PageLayout from '../../../layouts/PageLayout';
import Button from '../../../components/control/Button';
import CheckBox from '../../../components/control/CheckBox';
import SectionBar from '../../../components/SectionBar';
import TextBox from '../../../components/control/TextBox';

class GroupEdit extends React.Component {

  constructor(props) {
    super(props);

    // URLからグループコードを取得する(これによって新規か更新かを判断する)
    const { match } = this.props;
    this.grpcd = match.params.grpcd;

    this.handleRemoveItemClick = this.handleRemoveItemClick.bind(this);
    this.handleOkClick = this.handleOkClick.bind(this);
    this.handleCancelClick = this.handleCancelClick.bind(this);
    this.handleApplyClick = this.handleApplyClick.bind(this);
    this.handleRemoveClick = this.handleRemoveClick.bind(this);
    // this.handleConfirmItemGuide = this.handleConfirmItemGuide.bind(this);
  }

  componentWillMount() {
    // ロード時処理を呼び出す
    const { onLoad } = this.props;
    onLoad(this.grpcd);
  }

  // 登録時にPOSTするデータを作成する
  createPostData(formValues) {
    const { item, itemClass } = this.props;
    const classcd = formValues.classcd || itemClass[0].classcd;
    const systemgrp = formValues.systemgrp ? 1 : null;
    return { ...formValues, classcd, systemgrp, item };
  }

  // Okボタンクリック時の処理
  handleOkClick(values) {
    // 登録処理を行い、正常終了時は前画面に戻る
    // const { history, onRegister } = this.props;
    const { onRegister } = this.props;
    onRegister(this.grpcd, this.createPostData(values));
    // 本当はここで一覧画面に戻る実装が必要
    // (react-router-redixを使ってdispatch側で実装かも)
    // history.goBack();
  }

  // キャンセルボタンクリック時の処理
  handleCancelClick() {
    const { history } = this.props;
    history.goBack();
  }

  // 適用ボタンクリック時の処理
  handleApplyClick(values) {
    // 登録処理を行う
    // const { history, onRegister } = this.props;
    const { onRegister } = this.props;
    onRegister(this.grpcd, this.createPostData(values));
    // 本当はここでURLを置換する実装が必要
    // history.replace(`./${values.grpcd}`);
  }

  // 削除
  handleRemoveClick() {
    // 確認メッセージ
    // (とりあえずはconfirm文を使用しているが本来はダイアログのコンポーネントによる出力でなければならない)
    // eslint-disable-next-line no-alert
    if (!confirm('このデータを削除しますか？')) {
      return;
    }
    // 登録処理を行い、正常終了時はurlを新規登録用のそれに変更する
    // const { history, onDelete } = this.props;
    const { onDelete } = this.props;
    onDelete(this.grpcd);
    // 本当はここでURLを置換する実装が必要
    // history.replace(`./${values.grpcd}`);
  }

  // 検査項目削除ボタンクリックイベント定義
  handleRemoveItemClick() {
    // 選択済み（＝削除対象となる）検査項目として存在しない検査項目のみの配列を作成
    const items = Object.assign([], this.state.items).filter((rec) => !(`${rec.itemcd}-${rec.suffix}` in this.state.selectedItems));

    // stateの値を更新する
    this.setState({
      items,
      selectedItems: {},
    });
  }

  // // 項目ガイドで検査項目が選択、確定された場合の処理
  // handleConfirmItemGuide(selectedItems) {
  //   // 現在の検査項目（クローン）を取得
  //   const items = Object.assign([], this.state.items);

  //   // 現在の検査項目一覧に存在しない項目であれば末尾に追加
  //   Object.keys(selectedItems).forEach((key) => {
  //     // 選択された検査項目が現在の検査項目一覧に存在するかを判定
  //     const ret = items.some((rec) => ((rec.ITEMCD === selectedItems[key].itemcd) && (rec.SUFFIX === selectedItems[key].suffix)));

  //     // 存在しない場合は末尾に追加
  //     if (!ret) {
  //       items.push({
  //         itemcd: selectedItems[key].itemcd,
  //         suffix: selectedItems[key].suffix,
  //         itemname: selectedItems[key].itemname,
  //         classname: selectedItems[key].classname,
  //       });
  //     }
  //   });

  //   // stateの値を更新する
  //   this.setState({
  //     items,
  //     selectedItems: {},
  //   });
  // }

  render() {
    const { handleSubmit, initialValues, itemClass, message, visibleItemGuide, onOpenItemGuide, onCloseItemGuide } = this.props;
    return (
      <PageLayout icon="info" title="グループテーブルメンテナンス">
        {message.length > 0 && (
          <div>
            {message.map((rec, index) => (
              <p key={index.toString()}>{rec}</p>
            ))}
          </div>
        )}
        <form>
          <div>
            <SectionBar title="基本情報" />
            <div>
              グループの種類：
              {(initialValues.grpdiv === 1) ? '依頼項目を管理します' : '検査項目を管理します'}
            </div>
            <div style={{ marginTop: 10 }}>
              グループコード：
              <Field name="grpcd" component={TextBox} style={{ width: 100 }} disabled={(this.grpcd !== undefined)} />
            </div>
            <div style={{ marginTop: 10 }}>
              グループ名：
              <Field name="grpname" component={TextBox} style={{ width: 300 }} />
            </div>
            <div style={{ marginTop: 10 }}>
              検査分類：
              <Field name="classcd" component="select">
                {itemClass.map((rec) => (
                  <option key={rec.classcd} value={rec.classcd}>
                    {rec.classname}
                  </option>
                ))}
              </Field>
            </div>
            <div style={{ marginTop: 10 }}>
              検索用文字列：
              <Field name="searchchar" component="select">
                {Array.from(new Array(26)).map((value, index) => {
                  const chr = String.fromCharCode(index + 65);
                  return <option key={index.toString()} value={chr}>{chr}</option>;
                })}
                {['あ', 'か', 'さ', 'た', 'な', 'は', 'ま', 'や', 'ら', 'わ'].map((value, index) => (
                  <option key={index.toString()} value={value}>{value}</option>
                ))}
                <option value="*">その他</option>
              </Field>
            </div>
            <div style={{ marginTop: 10 }}>
              旧セットコード：
              <Field name="oldsetcd" component={TextBox} style={{ width: 100 }} />
            </div>
          </div>
          <div>
            <SectionBar title="検査項目" />
            <GroupEditItemTable />
            <div style={{ display: 'none' }}>
              <Button value="↑" />
              <Button value="↓" />
            </div>
            <div>
              <Button onClick={() => onOpenItemGuide()} value="追加" style={{ minWidth: 50 }} />
              <Button onClick={this.handleRemoveItemClick} value="削除" style={{ minWidth: 50 }} />
            </div>
          </div>
          <div>
            <Field name="systemgrp" component={CheckBox} checkedValue={1} label="このグループは通常業務画面に表示しない" />
          </div>
          <div style={{ marginTop: 20 }}>
            <Button type="submit" onClick={handleSubmit(this.handleOkClick)} value="Ok" />
            <Button onClick={this.handleCancelClick} value="キャンセル" />
            <Button onClick={handleSubmit(this.handleApplyClick)} value="適用" />
            <Button onClick={this.handleRemoveClick} disabled={(this.grpcd === undefined)} value="削除" />
          </div>
        </form>
        {/* <div>{this.state.username}</div> */}
        <ItemGuide show={visibleItemGuide} onOk={this.handleConfirmItemGuide} onClose={() => onCloseItemGuide()} />
      </PageLayout>
    );
  }
}

// propTypesの定義
GroupEdit.propTypes = {
  handleSubmit: PropTypes.func.isRequired,
  match: PropTypes.shape().isRequired,
  history: PropTypes.shape().isRequired,
  initialValues: PropTypes.shape().isRequired,
  itemClass: PropTypes.arrayOf(PropTypes.shape()).isRequired,
  item: PropTypes.arrayOf(PropTypes.shape()).isRequired,
  message: PropTypes.arrayOf(PropTypes.string).isRequired,
  onDelete: PropTypes.func.isRequired,
  onLoad: PropTypes.func.isRequired,
  onRegister: PropTypes.func.isRequired,
  onOpenItemGuide: PropTypes.func.isRequired,
  onCloseItemGuide: PropTypes.func.isRequired,
  visibleItemGuide: PropTypes.bool.isRequired,
};

const GroupEditForm = reduxForm({
  // form情報をstateで管理するためにアプリケーションで一意に名前を定義
  form: 'groupEdit',
  // initialValuesの値が変更される度にformを再初期化(=再表示)するために必要なプロパティ
  enableReinitialize: true,
})(GroupEdit);

const mapStateToProps = (state) => {
  const { group, item, message } = state.app.preference.group.groupEdit;
  const { data } = state.app.preference.itemClass.guide;
  const { show } = state.app.preference.item.guide;
  return {
    initialValues: group,
    itemClass: data,
    item,
    message,
    visibleItemGuide: show,
  };
};

// mapDispatchToPropsではreducerにactionを通知するためのdispatch処理をcomponentのpropsとしてどのように混ぜ込むかを定義する
const mapDispatchToProps = (dispatch) => ({
  // ロード時の処理
  onLoad: (grpcd) => {
    // 初期化
    dispatch(initializeGroup());
    // 全検査分類の取得(ドロップダウンリスト表示用)
    dispatch(getAllItemClasses());
    // グループコード定義時はグループ取得処理を呼び出す
    if (grpcd !== undefined) {
      dispatch(getGroupRequest(grpcd));
    }
  },
  // 登録時の処理
  onRegister: (grpcd, group) => (
    // 登録処理を呼び出す
    dispatch(registerGroupRequest({ grpcd, group }))
  ),
  // 削除時の処理
  onDelete: (grpcd) => (
    // 削除処理を呼び出す
    dispatch(deleteGroupRequest(grpcd))
  ),
  // 検査項目ガイドオープン時の処理
  onOpenItemGuide: () => (
    dispatch(showItemGuide())
  ),
  // 検査項目ガイドクローズ時の処理
  onCloseItemGuide: () => (
    dispatch(hideItemGuide())
  ),
});

export default connect(mapStateToProps, mapDispatchToProps)(GroupEditForm);
