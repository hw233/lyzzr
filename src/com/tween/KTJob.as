﻿package com.tween {
import com.tween.easing.Quad;
import laya.events.Event;
import laya.events.EventDispatcher;
import laya.utils.Handler;
import utils.TimerUtil;
[Event(name="init", type="flash.events.Event")]

	[Event(name="change", type="flash.events.Event")]

	[Event(name="complete", type="flash.events.Event")]

	[Event(name="close", type="flash.events.Event")]


	[Event(name="cancel", type="flash.events.Event")]

	public class KTJob extends EventDispatcher {
		/**
		 * Name of the tween job.
		 */
		public var name:String;
		/**
		 * The length of the tween in seconds.
		 */
		public var duration:Number = 1.0;
		/**
		 * The target object to tween.
		 */
		public var target:*;
		/**
		 * The object which contains the first (beginning) status in each property.
		 * In case of null, the current propeties would be copied from the target object.
		 */
		public var from:Object;
		/**
		 * The object which contains the last (ending) status in each property.
		 * In case of null, the current propeties would be copied from the target object.
		 */
		public var to:Object;
		/**
		 * The easing equation function.
		 */
		public var ease:Function = Quad.easeOut;
		/**
		 * True after the job was finished including completed, canceled and aborted.
		 */
		public var finished:Boolean = false;
		/**
		 * Set true to round the result value to the nearest integer number.
		 */
		public var round:Boolean = false;
		/**
		 * Set true to repeat the tween from the beginning after finished.
		 */
		public var repeat:Boolean = false;
		/**
		 * Set true to repeat the tween reverse back from the ending after finished.
		 * repeat property must be true.
		 */
		public var yoyo:Boolean = false;
		/**
		 * The callback function invoked when the tween job has just started.<br/>
		 * Note this would not work with KTween's static methods, 
		 * ex. <code>KTween.fromTo()</code>,
		 * as these methods start a job at the same time.
		 */
		public var onInit:Handler;
		/**
		 * The callback function invoked when the value chaned.
		 */
		public var onChange:Handler;
		/**
		 * The callback function invoked when the tween job has just completed.<br/>
		 * Note this would be invoked before the Flash Player renders the object 
		 * at the final position.
		 */
		public var onComplete:Handler;
		/**
		 * The callback function invoked when the tween job is closing.<br/>
		 * Note this would be invoked at the next <code>ENTER_FRAME</code> event of onComplete.
		 */
		public var onClose:Handler;
		/**
		 * The callback function invoked when the tween job is canceled.
		 */
		public var onCancel:Handler;
		/**
		 * Arguments for onInit callback function.
		 */
		public var onInitParams:Array;
		/**
		 * Arguments for onChange callback function.
		 */
		public var onChangeParams:Array;
		/**
		 * Arguments for onComplete callback function.
		 */
		public var onCompleteParams:Array;
		/**
		 * Arguments for onClose callback function.
		 */
		public var onCloseParams:Array;
		/**
		 * Arguments for onCancel callback function.
		 */
		public var onCancelParams:Array;
		/**
		 * The next tween job instance managed by KTManager. Do not modify this.
		 * @see com.tween.KTManager
		 */
		public var next:KTJob;
		private var reverse:Boolean = false;
		private var initialized:Boolean = false;
		private var canceled:Boolean = false;
		private var pausing:Boolean = false;
		private var startTime:Number;
		private var lastTime:Number;
		private var firstProp:_KTProperty;
		private var invokeEvent:Boolean = false;

		/**
		 * Constructs a new KTJob instance.
		 *
		 * @param target 	The object whose properties will be tweened.
		 **/
		public final function KTJob(target:*):void {
			this.target = target;
		}

		/**
		 * Initializes from/to values of the tween job.
		 * @param curTime The current time in milliseconds given by getTimer() method. Optional.
		 * @see flash.utils#getTimer()
		 */
		public function init(curTime:Number = -1):void {
			if (initialized) return;
			if (finished) return;
			if (canceled) return;
			if (pausing) return;

			// get current time
			if (curTime < 0) {
				curTime = TimerUtil.getTimer();
			}
			startTime = curTime;

			setupValues();
			initialized = true;
			
			// activated
			if (onInit is Handler) {
				onInit.runWith(onInitParams);
			}
			if (invokeEvent) {
                event(Event.INIT);
			}
		}

		private function setupValues():void {
			var first:Object = (from != null) ? from : target;
			var last:Object = (to != null) ? to : target;
			var keys:Object = (to != null) ? to : from;
			if (keys == null) return;

			var p:_KTProperty;
			var lastProp:_KTProperty;
			for (var key:String in keys) {
				if (first[key] == last[key]) continue; // skip this
				p = new _KTProperty(key, first[key], last[key]);
				if (firstProp == null) {
					firstProp = p;
				} else {
					lastProp.next = p;
				}
				lastProp = p;
			}
			if (from != null) {
				applyFirstValues();
			}
		}

		private function applyFirstValues():void {
			var p:_KTProperty;
			for(p = firstProp;p != null;p = p.next) {
				target[p.key] = p.from;
			}
			if (onChange is Handler) {
				onChange.runWith(  onChangeParams);
			}
			if (invokeEvent) {
                event(Event.CHANGE);
			}
		}

		private function applyFinalValues():void {
			var p:_KTProperty;
			for(p = firstProp;p != null;p = p.next) {
				target[p.key] = p.to;
			}
			if (onChange is Handler) {
				onChange.runWith(  onChangeParams);
			}
			if (invokeEvent) {
                event(Event.CHANGE);
			}
		}

		/**
		 * Steps the sequence by every ticks invoked by ENTER_FRAME event.
		 * @param curTime The current time in milliseconds given by getTimer() method. Optional.
		 * @see flash.utils#getTimer()
		 */
		public function step(curTime:Number = -1):void {
			if (finished) return;
			if (canceled) return;
			if (pausing) return;
			
			// get current time
			if (curTime < 0) {
				curTime = TimerUtil.getTimer();
			}
			
			// not started yet
			if (!initialized) {
				init(curTime);
				return;
			}

			// check invoked in the same time
			if (lastTime == curTime) return;
			lastTime = curTime;
			
			// check finished
			var secs:Number = (curTime - startTime) * 0.001;
			if (secs >= duration) {
				if (repeat) {
					if (yoyo) {
						reverse = !reverse;
					}
					secs -= duration;
					startTime = curTime - secs * 1000;
				} else {
					complete();
					return;
				}
			}

			// tweening
			var pos:Number = secs / duration;
			if (reverse) {
				pos = 1 - pos;
			}
			if (ease is Function) {
				pos = ease(pos);
			}
			
			// update
			var p:_KTProperty;
			if (round) {
				for(p = firstProp;p != null;p = p.next) {
					target[p.key] = Math.round(p.from + p.diff * pos);
				}
			} else {
				for(p = firstProp;p != null;p = p.next) {
					target[p.key] = p.from + p.diff * pos;
				}
			}
			if (onChange is Handler) {
				onChange.runWith(  onChangeParams);
			}
			if (invokeEvent) {
                event(Event.CHANGE);
			}
		}

		/**
		 * Forces to finish the tween job.
		 */
		public function complete():void {
			if (!initialized) return;
			if (finished) return;
			if (canceled) return;
			// if (!to) return;
			if (!target) return;
			
			applyFinalValues();

			finished = true;
			if (onComplete is Handler) {
				onComplete.runWith(  onCompleteParams);
			}
			if (invokeEvent) {
                event(Event.COMPLETE);
			}
		}

		/**
		 * Stops and rollbacks to the first (beginning) status of the tween job.
		 */
		public function cancel():void {
			if (!initialized) return;
			if (canceled) return;
			// if (!from) return;
			if (!target) return;
			
			applyFirstValues();
			
			finished = true;
			canceled = true;
			if (onCancel is Handler) {
				onCancel.runWith(  onCancelParams);
			}
			if (invokeEvent) {
                event(Event.CANCEL);
			}
		}

		/**
		 * Closes the tween job
		 */
		public function close():void {
			if (!initialized) return;
			if (canceled) return;
			
			finished = true;
			if (onClose is Handler) {
				onClose.runWith(  onCloseParams);
			}
			if (invokeEvent) {
                event(Event.CLOSE);
			}
			clearnup();
		}

		/**
		 * @private
		 */
		protected function clearnup():void {
            onInit&&onInit.clear();
            onChange&&onChange.clear();
            onComplete&&onComplete.clear();
            onCancel&&onCancel.clear();
            onClose&&onClose.clear();

			onInit = null;
			onChange = null;
			onComplete = null;
			onCancel = null;
			onClose = null;
			onInitParams = null;
			onChangeParams = null;
			onCompleteParams = null;
			onCloseParams = null;
			onCancelParams = null;
			firstProp = null;
			invokeEvent = false;


		}

		/**
		 * Terminates the tween job immediately.
		 */
		public function abort():void {
			finished = true;
			canceled = true;
			clearnup();
		}

		/**
		 * Pauses the tween job.
		 */
		public function pause():void {
			if (pausing) return;
			pausing = true;
			lastTime = TimerUtil.getTimer();
		}

		/**
		 * Proceeds with the tween jobs paused.
		 */
		public function resume():void {
			if (!pausing) return;
			pausing = false;
			var curTime:Number = TimerUtil.getTimer();
			startTime = curTime - (lastTime - startTime);
			step(curTime);
		}

		/**
		 * @private
		 */
		public  function addEventListener(type:String, caller:*, listener:Function, args:Array, once:Boolean, offBefore:Boolean = true ):void {
			super._createListener(type, caller,listener, args, once, offBefore);
			invokeEvent = true;
		}
	}
}

internal final class _KTProperty {
	public var key:String;
	public var from:Number;
	public var to:Number;
	public var diff:Number;
	public var next:_KTProperty;

	public function _KTProperty(key:String, from:Number, to:Number, next:_KTProperty = null):void {
		this.key = key;
		this.from = from;
		this.to = to;
		this.diff = to - from;
		this.next = next;
	}
}
